defmodule TimeZoneInfo.UpdaterTest do
  use ExUnit.Case

  import ExUnit.CaptureLog
  import TimeZoneInfo.TestUtils

  alias TimeZoneInfo.{
    DataPersistence.Priv,
    DataStore,
    DataStore.ErlangTermStorage,
    DataStore.PersistentTerm,
    TimeZoneDatabase,
    Updater
  }

  @seconds_per_hour 60 * 60
  @seconds_per_day 24 * @seconds_per_hour
  @path "test/data.etf"
  @fixture "data/2019c/extract/africa/data.etf"
  @delta_seconds 30

  setup do
    cp_data(@fixture, @path)

    data_store =
      if function_exported?(:persistent_term, :get, 0) do
        PersistentTerm
      else
        ErlangTermStorage
      end

    data_store.delete!()

    # The commented out lines show the default value of the configuration entry.
    put_env(
      lookahead: 1,
      # files: ~w(africa antarctica asia australasia etcetera europe northamerica southamerica),
      files: ~w(africa),
      downloader: [
        module: TimeZoneInfo.Downloader.Mint,
        # uri: "https://data.iana.org/time-zones/tzdata-latest.tar.gz",
        uri: "http://localhost:1234/fixtures/iana/2019c.tar.gz",
        mode: :iana
      ],
      # update: :disabled,
      update: :daily,
      # data_store: :auto,
      data_store: data_store,
      data_persistence: TimeZoneInfo.DataPersistence.Priv,
      # priv: [path: "data.etf"]
      priv: [path: @path],
      # none default config
      listener: TimeZoneInfo.Listener.Logger
    )

    on_exit(fn ->
      rm_data(@path)
      delete_env()
      data_store.delete!()
    end)
  end

  describe "update/0" do
    test "tries to update old file" do
      touch_data(@path, now(sub: 2 * @seconds_per_day))
      checksum = checksum(@path)

      assert DataStore.empty?()

      assert_log(
        fn ->
          assert {:next, timestamp} = Updater.update()
          assert_in_delta(timestamp, now(add: @seconds_per_day), @delta_seconds)
        end,
        [:initial, :check, :download, :up_to_date]
      )

      refute DataStore.empty?()
      assert checksum(@path) == checksum
    end

    test "force with disabled updater" do
      update_env(update: :disabled)

      assert_log(
        fn ->
          assert :ok = Updater.update(:force)
        end,
        [:force]
      )
    end

    test "tries to update old file and new config" do
      update_env(files: ~w(europe))
      touch_data(@path, now(sub: 2 * @seconds_per_day))
      checksum = checksum(@path)

      assert DataStore.empty?()

      assert_log(
        fn ->
          assert {:next, timestamp} = Updater.update()
          assert_in_delta(timestamp, now(add: @seconds_per_day), @delta_seconds)
        end,
        [:initial, :check, :download, :update]
      )

      refute DataStore.empty?()
      assert checksum(@path) != checksum
    end

    test "tries to update with an actual file" do
      touch_data(@path, now(sub: @seconds_per_hour))
      checksum = checksum(@path)

      assert DataStore.empty?()

      assert_log(
        fn ->
          assert {:next, timestamp} = Updater.update()
          assert_in_delta(timestamp, now(add: 23 * @seconds_per_hour), @delta_seconds)
        end,
        [:initial, :check]
      )

      refute DataStore.empty?()
      assert checksum(@path) == checksum
    end

    test "tries to update with an actual file and new config" do
      update_env(files: ~w(europe)a)
      touch_data(@path, now(sub: @seconds_per_hour))
      checksum = checksum(@path)

      assert DataStore.empty?()

      assert_log(
        fn ->
          assert {:next, timestamp} = Updater.update()
          assert_in_delta(timestamp, now(add: 23 * @seconds_per_hour), @delta_seconds)
        end,
        [:initial, :check]
      )

      refute DataStore.empty?()
      assert checksum(@path) == checksum
    end

    test "writes data file if it is not exist" do
      rm_data(@path)
      mkdir_data(@path)

      refute data_exists?(@path)
      assert DataStore.empty?()

      assert_log(
        fn ->
          assert {:next, timestamp} = Updater.update()
          assert_in_delta(timestamp, now(add: @seconds_per_day), @delta_seconds)
        end,
        [:initial, :force, :download, :update]
      )

      refute DataStore.empty?()
      assert data_exists?(@path)
    end

    test "downloads direct etf data" do
      rm_data(@path)
      mkdir_data(@path)

      update_env(
        # files are not needed
        files: [],
        downloader: [
          module: TimeZoneInfo.Downloader.Mint,
          uri: "http://localhost:1234/fixtures/data/2019c/extract/africa/data.etf",
          mode: :etf
        ]
      )

      refute data_exists?(@path)
      assert DataStore.empty?()

      assert_log(
        fn ->
          assert {:next, timestamp} = Updater.update()
          assert_in_delta(timestamp, now(add: @seconds_per_day), @delta_seconds)
        end,
        [:initial, :force, :download, :update]
      )

      refute DataStore.empty?()
      assert data_exists?(@path)

      assert periods(~N[2012-03-25 01:59:59], "Indian/Mauritius") ==
               {:ok, %{std_offset: 0, utc_offset: 14400, zone_abbr: "+04"}}
    end

    test "downloads data from a web service" do
      rm_data(@path)
      mkdir_data(@path)

      update_env(
        files: ~w(europe),
        downloader: [
          module: TimeZoneInfo.Downloader.Mint,
          uri: "http://localhost:1234/api/time_zone_info",
          mode: :ws,
          headers: [
            {"Content-Type", "application/gzip"},
            {"User-Agent", "Elixir.TimeZoneInfo.Mint"}
          ]
        ]
      )

      refute data_exists?(@path)
      assert DataStore.empty?()

      assert_log(
        fn ->
          assert {:next, timestamp} = Updater.update()
          assert_in_delta(timestamp, now(add: @seconds_per_day), @delta_seconds)
        end,
        [:initial, :force, :download, :update]
      )

      refute DataStore.empty?()
      assert data_exists?(@path)
      assert Enum.member?(TimeZoneInfo.time_zones(), "Europe/Amsterdam")
      refute Enum.member?(TimeZoneInfo.time_zones(), "America/New_York")

      assert periods(~N[2012-03-25 01:59:59], "Europe/Berlin") ==
               {:ok, %{std_offset: 0, utc_offset: 3600, zone_abbr: "CET"}}
    end

    test "server return 304 if data is unchanged" do
      touch_data(@path, now(sub: @seconds_per_day * 2))

      update_env(
        files: ~w(africa),
        downloader: [
          module: TimeZoneInfo.Downloader.Mint,
          uri: "http://localhost:1234/api/time_zone_info",
          mode: :ws,
          headers: [
            {"content-type", "application/gzip"},
            {"user-agent", "Elixir.TimeZoneInfo.Mint"}
          ]
        ]
      )

      assert DataStore.empty?()

      assert_log(
        fn ->
          assert {:next, timestamp} = Updater.update()
        end,
        [:initial, :check, :download, :up_to_date]
      )

      refute DataStore.empty?()
    end

    test "server return 304 if data is unchanged and update forced" do
      update_env(
        files: ~w(africa),
        downloader: [
          module: TimeZoneInfo.Downloader.Mint,
          uri: "http://localhost:1234/api/time_zone_info",
          mode: :ws,
          headers: [
            {"content-type", "application/gzip"},
            {"user-agent", "Elixir.TimeZoneInfo.Mint"}
          ]
        ]
      )

      assert data_exists?(@path)
      assert DataStore.empty?()

      assert_log(
        fn ->
          assert {:next, timestamp} = Updater.update(:force)
          assert_in_delta(timestamp, now(add: @seconds_per_day), @delta_seconds)
        end,
        [:force, :download, :up_to_date]
      )

      assert DataStore.empty?()
    end

    test "server returns 500" do
      touch_data(@path, now(sub: 2 * @seconds_per_day))

      update_env(
        downloader: [
          module: TimeZoneInfo.Downloader.Mint,
          uri: "http://localhost:1234/api/error",
          mode: :ws
        ]
      )

      assert data_exists?(@path)
      assert DataStore.empty?()

      assert_log(
        fn ->
          assert {:error, {500, "You Want It, You Got It"}} = Updater.update()
        end,
        [:initial, :check, :download, :error]
      )
    end

    test "server returns 500 on forced update" do
      update_env(
        downloader: [
          module: TimeZoneInfo.Downloader.Mint,
          uri: "http://localhost:1234/api/error",
          mode: :ws
        ]
      )

      assert data_exists?(@path)
      assert DataStore.empty?()

      assert_log(
        fn ->
          assert {:error, {500, "You Want It, You Got It"}} = Updater.update(:force)
        end,
        [:force, :download, :error]
      )
    end

    test "gets an error if the data is not on the server" do
      rm_data(@path)
      mkdir_data(@path)

      update_env(
        # files are not needed
        files: [],
        downloader: [
          module: TimeZoneInfo.Downloader.Mint,
          uri: "http://localhost:1234/fixtures/data/2019c/extract/missing/data.etf",
          mode: :etf
        ]
      )

      refute data_exists?(@path)
      assert DataStore.empty?()

      assert_log(
        fn ->
          assert {:error, {404, "Not Found"}} = Updater.update()
        end,
        [:initial, :force, :download, :error]
      )

      assert DataStore.empty?()
    end

    test "gets an error if ..." do
      rm_data(@path)
      mkdir_data(@path)

      update_env(
        # files are not needed
        files: [],
        downloader: [
          module: TimeZoneInfo.Downloader.Mint,
          uri: "http://localhost:666",
          mode: :etf
        ]
      )

      refute data_exists?(@path)
      assert DataStore.empty?()

      assert_log(
        fn ->
          assert {:error, {:error, _}} = Updater.update()
        end,
        [:initial, :force, :download, :error]
      )
    end

    test "updates data for europe and etcetera" do
      update_env(files: ~w(europe etcetera))
      touch_data(@path, now(sub: 2 * @seconds_per_day))

      assert_log(
        fn ->
          assert {:next, _timestamp} = Updater.update()
        end,
        [:initial, :check, :download, :update]
      )

      assert periods(~N[2012-03-25 01:59:59], "Europe/Berlin") ==
               {:ok, %{std_offset: 0, utc_offset: 3600, zone_abbr: "CET"}}

      assert periods(~N[2012-03-25 01:59:59], "Europe/London") == {
               :gap,
               {%{std_offset: 0, utc_offset: 0, zone_abbr: "GMT"}, ~N[2012-03-25 01:00:00]},
               {%{std_offset: 3600, utc_offset: 0, zone_abbr: "BST"}, ~N[2012-03-25 02:00:00]}
             }

      assert periods(~N[2012-03-25 01:59:59], "Etc/Zulu") ==
               {:ok, %{std_offset: 0, utc_offset: 0, zone_abbr: "UTC"}}

      assert periods(~N[2012-03-25 01:59:59], "Etc/GMT+4") ==
               {:ok, %{std_offset: 0, utc_offset: -14400, zone_abbr: "-04"}}
    end

    test "updates data filtered by time_zones" do
      update_env(
        files: ~w(africa europe),
        time_zones: ["Europe/Berlin", "Indian"]
      )

      touch_data(@path, now(sub: 2 * @seconds_per_day))

      assert_log(
        fn ->
          assert {:next, _timestamp} = Updater.update()
        end,
        [:initial, :force, :download, :update]
      )

      assert TimeZoneInfo.time_zones(links: :ignore) == [
               "Europe/Berlin",
               "Indian/Mahe",
               "Indian/Mauritius",
               "Indian/Reunion"
             ]

      assert TimeZoneInfo.time_zones(links: :only) == []
    end

    test "updates data filtered by time_zones (forced update)" do
      update_env(
        files: ~w(europe asia),
        time_zones: ["Europe/Berlin", "Indian"]
      )

      touch_data(@path, now(sub: 2 * @seconds_per_day))

      assert_log(
        fn ->
          assert {:next, _timestamp} = Updater.update()
        end,
        [:initial, :force, :download, :update]
      )

      assert TimeZoneInfo.time_zones() == ["Europe/Berlin", "Indian/Chagos", "Indian/Maldives"]
    end

    test "updates data filtered by time_zones (update: :disabled)" do
      update_env(
        update: :disabled,
        time_zones: ["Africa/Lagos", "Indian"]
      )

      assert_log(
        fn ->
          assert :ok = Updater.update()
        end,
        [:initial, :check]
      )

      assert TimeZoneInfo.time_zones(links: :ignore) == [
               "Africa/Lagos",
               "Indian/Mahe",
               "Indian/Mauritius",
               "Indian/Reunion"
             ]

      assert TimeZoneInfo.time_zones(links: :only) == [
               "Africa/Bangui",
               "Africa/Brazzaville",
               "Africa/Douala",
               "Africa/Kinshasa",
               "Africa/Libreville",
               "Africa/Luanda",
               "Africa/Malabo",
               "Africa/Niamey",
               "Africa/Porto-Novo"
             ]
    end

    test "runs initial update once" do
      assert_log(
        fn ->
          assert {:next, timestamp} = Updater.update()
        end,
        [:initial, :check]
      )

      assert_log(
        fn ->
          assert {:next, timestamp} = Updater.update()
        end,
        :check
      )
    end

    test "does not download data after update" do
      touch_data(@path, now(sub: 2 * @seconds_per_day))

      assert_log(
        fn ->
          assert {:next, timestamp} = Updater.update()
        end,
        [:initial, :check, :download, :up_to_date]
      )

      assert_log(
        fn ->
          assert {:next, timestamp} = Updater.update()
        end,
        [:check]
      )
    end
  end

  describe "update/0 returns error" do
    test "without any config" do
      delete_env()

      assert_raise ArgumentError, fn ->
        Updater.update()
      end
    end

    test "without invalid config" do
      delete_env()

      put_env(
        data_store: ErlangTermStorage,
        data_persistence: Priv
      )

      assert Updater.update() == {:error, {:invalid_config, :priv}}
    end

    test "for invalid time_zones" do
      touch_data(@path, now(sub: 2 * @seconds_per_day))

      update_env(time_zones: :foo)

      assert_log(
        fn ->
          assert Updater.update() == {:error, {:invalid_config, [time_zones: :foo]}}
        end,
        [:initial, :error]
      )
    end

    test "for invalid time zone in time_zones" do
      touch_data(@path, now(sub: 2 * @seconds_per_day))

      update_env(time_zones: [:foo])

      assert_log(
        fn ->
          assert Updater.update() == {:error, {:invalid_config, [time_zones: [:foo]]}}
        end,
        [:initial, :error]
      )
    end
  end

  defp periods(datetime, time_zone),
    do: TimeZoneDatabase.time_zone_periods_from_wall_datetime(datetime, time_zone)

  defp assert_log(fun, step) when is_atom(step), do: assert_log(fun, [step])

  defp assert_log(fun, steps) do
    log = capture_log(fun)

    Enum.each(
      %{
        initial: "TimeZoneInfo: Initializing data.",
        check: "TimeZoneInfo: Checking for update.",
        download: "TimeZoneInfo: Downloading data.",
        update: "TimeZoneInfo: Updating data.",
        up_to_date: "TimeZoneInfo: No update available.",
        force: "TimeZoneInfo: Force update.",
        error: "TimeZoneInfo: Update failed!"
      },
      fn {step, info} ->
        case Enum.member?(steps, step) do
          true ->
            assert log =~ info, ~s(assert log: "#{info}\nfound logs: #{log}")

          false ->
            refute log =~ info, ~s(refute log: "#{info}\nfound logs: #{log}")
        end
      end
    )
  end
end
