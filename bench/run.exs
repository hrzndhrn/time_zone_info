Enum.each(
  [
    "bench/time_zone_database.exs",
    "bench/transform.exs"
  ],
  &Code.eval_file(&1, File.cwd!())
)

# Bench.TimeZoneDatabase.run()
Bench.Transform.run()
