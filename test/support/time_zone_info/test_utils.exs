defmodule TimeZoneInfo.TestUtils do
  alias Calendar.ISO
  alias TimeZoneInfo.ExternalTermFormat

  @microsecond {0, 0}

  def put_app_env(env) do
    delete_app_env()
    update_env(env)
  end

  def update_env(env) do
    Enum.each(env, fn {key, value} ->
      Application.put_env(:time_zone_info, key, value)
    end)

    Application.get_all_env(:time_zone_info)
  end

  def delete_app_env do
    :time_zone_info
    |> Application.get_all_env()
    |> Keyword.keys()
    |> Enum.each(fn key ->
      # don't delete envs used by tests
      unless key in [:checker, :updater] do
        Application.delete_env(:time_zone_info, key)
      end
    end)
  end

  def rm_priv_data(path) do
    :time_zone_info
    |> :code.priv_dir()
    |> Path.join(path)
    |> File.rm()
  end

  def priv_data_exists?(path) do
    :time_zone_info
    |> :code.priv_dir()
    |> Path.join(path)
    |> File.exists?()
  end

  def cp_priv_data(fixture, path) do
    source = File.cwd!() |> Path.join("test/fixtures") |> Path.join(fixture)
    destination = :time_zone_info |> :code.priv_dir() |> Path.join(path)
    mkdir_priv_data(path)

    File.cp!(source, destination)
  end

  def mkdir_priv_data(path) do
    :time_zone_info
    |> :code.priv_dir()
    |> Path.join(Path.dirname(path))
    |> File.mkdir_p()
  end

  def checksum(path) do
    :time_zone_info
    |> :code.priv_dir()
    |> Path.join(path)
    |> File.read!()
    |> ExternalTermFormat.checksum()
  end

  def set_priv_timestamp(path, timestamp) when is_integer(timestamp) do
    :time_zone_info
    |> :code.priv_dir()
    |> Path.join(path)
    |> File.write!(to_string(timestamp))
  end

  def get_priv_timestamp(path) do
    :time_zone_info
    |> :code.priv_dir()
    |> Path.join(path)
    |> File.read!()
    |> String.trim()
    |> String.to_integer()
  end

  def now, do: now(add: 0)

  def now(sub: value), do: now(add: value * -1)

  def now(add: value) do
    DateTime.utc_now() |> DateTime.add(value) |> DateTime.to_unix()
  end

  def to_iso_days(%NaiveDateTime{year: yr, month: mo, day: dy, hour: hr, minute: m, second: s}),
    do: ISO.naive_datetime_to_iso_days(yr, mo, dy, hr, m, s, @microsecond)
end
