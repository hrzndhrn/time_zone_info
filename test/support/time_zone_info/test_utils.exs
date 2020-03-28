defmodule TimeZoneInfo.TestUtils do
  alias TimeZoneInfo.ExternalTermFormat

  def put_env(env) do
    delete_env()
    update_env(env)
  end

  def update_env(env) do
    Enum.each(env, fn {key, value} ->
      Application.put_env(:time_zone_info, key, value)
    end)
  end

  def delete_env do
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

  def rm_data(path) do
    :time_zone_info
    |> :code.priv_dir()
    |> Path.join(path)
    |> File.rm()

    :time_zone_info
    |> :code.priv_dir()
    |> Path.join(Path.dirname(path))
    |> File.rmdir()
  end

  def data_exists?(path) do
    :time_zone_info
    |> :code.priv_dir()
    |> Path.join(path)
    |> File.exists?()
  end

  def cp_data(fixture, path) do
    source = File.cwd!() |> Path.join("test/fixtures") |> Path.join(fixture)
    destination = :time_zone_info |> :code.priv_dir() |> Path.join(path)
    mkdir_data(path)

    File.cp!(source, destination)
  end

  def mkdir_data(path) do
    :time_zone_info
    |> :code.priv_dir()
    |> Path.join(Path.dirname(path))
    |> File.mkdir()
  end

  def touch_data(path, time) do
    :time_zone_info
    |> :code.priv_dir()
    |> Path.join(path)
    |> File.touch(time)
  end

  def checksum(path) do
    :time_zone_info
    |> :code.priv_dir()
    |> Path.join(path)
    |> File.read!()
    |> ExternalTermFormat.checksum()
  end

  def now, do: now(add: 0)

  def now(sub: value), do: now(add: value * -1)

  def now(add: value) do
    DateTime.utc_now() |> DateTime.add(value) |> DateTime.to_unix()
  end
end
