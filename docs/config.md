# Config

Add the following line to use `TimeZoneInfo` per default in the project.
```
config :elixir, :time_zone_database, TimeZoneInfo.TimeZoneDatabase
```

## Enable automated updates

The automated update uses the default `Downloader`, and this one uses
[`Mint`](https://github.com/elixir-mint/mint). Therefore the following
dependencies are needed in `mix.exs`.
```
defp deps do
  [
    ...
    {:castore, "~> 0.1.0"},
    {:mint, "~> 1.0"},
    ...
  ]
end
```
The config has to be extended with:
```
config :time_zone_info, update: :daily
```

## Custom downloader

It is also possible to use your own downloader. This requires an implementation
of the behaviour `TimeZoneInfo.Downloader`. The custom downloader has to be
specified in the config.
```
config :time_zone_info, [
  update: :daily,
  downloader: [
    module: MyApp.TimeZonInfo.Downloader,
    uri: "https://data.iana.org/time-zones/tzdata-latest.tar.gz",
    format: :iana,
    headers: [
      {"Content-Type", "application/tar+gzip"},
      {"User-Agent", "Elixir.TimeZoneInfo.Mint"}
    ]
  ],
]
```

The option `update` specifies the update interval. Possible values are `:daily`
and `:disabled` to disable the automated update.

The keys `uri` and `headers` containing to download the data.

The key `format` can contain `:iana` or `:etf` and indicates whether they data
are delivered in IANA format (.tar.gz) or in zipped ETF (External Term Format).

## Time zone manipulation

`TimeZoneInfo` provides some configuration options to select a subset form the
available time zones and the size of the generated periods table.

`files:`\
Default: `~w(africa antarctica asia australasia etcetera europe
northamerica southamerica)`\
This option specifies which files are parsed from the IANA data. The files
`europe`, `asia`, etc are self-explanatory. The file `ecetera` contains time
zones like `Etc/UTC`, `Etc/Zulu`, `Etc/GMT+1`, etc.

`time_zones:`\
Default: `:all`\
With `time_zones:` you can determine which time zones should be used. This
configuration expected a list of time zone names and/or areas like
`["Asia", "Europe/Berlin"]`. In this example all time zones in the area Asia and
the time zone "Europe/Berlin" are available. The `links` that points to the
available time zones will be also available.

`lookahead:`\
Default: `5`\
The `lookahead` specifies for how many years from now the periods will be
calculated.

## No runtime config, no delete

It is not recomented to update the configuration at runtime. Becaus the data
in runtime will just be updated but never deleted. That means if you change
`time_zones: :all` to `time_zones: ["Europe"]` then **all** time zones are
available after an update.

This is not a problem for the automated update. Because all period tables will
be updated.

## The data store

`TimeZoneInfo` provides two methods to store data at runtime.
The data can be stored either with `:persistent_term` or with `:ets`. The option
`data_store` holds this configuration. With `data_store: :detect` (default) the
method with `:persistent_term` will be used if `:persitent_term` is available
(OTP >= 21.2). To set a method explicitly use
`data_store: TimeZoneInfo.DataStore.PersistentTerm` or
`data_store: TimeZoneInfo.DataStore.ErlangTermStorage`.
