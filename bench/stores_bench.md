Benchmark: TimeZoneDatabase Storage

This benchmark compares the different `DataStores` available in
`TimeZoneInfo`.

The `TimeZoneInfo` will be tested in three different configurations.
Each version uses a different strategy to keep the data available.
- `pst` is using
  [`:persistent_term`](https://erlang.org/doc/man/persistent_term.html)
- `ets` is using `:ets`
  [(Erlang Term Storage)](https://erlang.org/doc/man/ets.html)
- `map` is using a `GenServer` with a `Map` as state. This
  version isn't an available configuration in `TimeZoneInfo`. The
  `GenServer` version is otherwise only used in the tests.


## System

Benchmark suite executing on the following system:

<table style="width: 1%">
  <tr>
    <th style="width: 1%; white-space: nowrap">Operating System</th>
    <td>macOS</td>
  </tr><tr>
    <th style="white-space: nowrap">CPU Information</th>
    <td style="white-space: nowrap">Apple M1</td>
  </tr><tr>
    <th style="white-space: nowrap">Number of Available Cores</th>
    <td style="white-space: nowrap">8</td>
  </tr><tr>
    <th style="white-space: nowrap">Available Memory</th>
    <td style="white-space: nowrap">16 GB</td>
  </tr><tr>
    <th style="white-space: nowrap">Elixir Version</th>
    <td style="white-space: nowrap">1.14.1</td>
  </tr><tr>
    <th style="white-space: nowrap">Erlang Version</th>
    <td style="white-space: nowrap">25.1.2</td>
  </tr>
</table>

## Configuration

Benchmark suite executing with the following configuration:

<table style="width: 1%">
  <tr>
    <th style="width: 1%">:time</th>
    <td style="white-space: nowrap">10 s</td>
  </tr><tr>
    <th>:parallel</th>
    <td style="white-space: nowrap">1</td>
  </tr><tr>
    <th>:warmup</th>
    <td style="white-space: nowrap">2 s</td>
  </tr>
</table>

## Statistics



__Input: Europe/Berlin__

Run Time

<table style="width: 1%">
  <tr>
    <th>Name</th>
    <th style="text-align: right">IPS</th>
    <th style="text-align: right">Average</th>
    <th style="text-align: right">Devitation</th>
    <th style="text-align: right">Median</th>
    <th style="text-align: right">99th&nbsp;%</th>
  </tr>

  <tr>
    <td style="white-space: nowrap">pst</td>
    <td style="white-space: nowrap; text-align: right">2213.26 K</td>
    <td style="white-space: nowrap; text-align: right">0.45 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;7218.25%</td>
    <td style="white-space: nowrap; text-align: right">0.38 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">1.25 &micro;s</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">ets</td>
    <td style="white-space: nowrap; text-align: right">43.77 K</td>
    <td style="white-space: nowrap; text-align: right">22.85 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;75.51%</td>
    <td style="white-space: nowrap; text-align: right">20.29 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">45.71 &micro;s</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">map</td>
    <td style="white-space: nowrap; text-align: right">41.16 K</td>
    <td style="white-space: nowrap; text-align: right">24.29 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;35.17%</td>
    <td style="white-space: nowrap; text-align: right">21.83 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">45.58 &micro;s</td>
  </tr>

</table>


Run Time Comparison

<table style="width: 1%">
  <tr>
    <th>Name</th>
    <th style="text-align: right">IPS</th>
    <th style="text-align: right">Slower</th>
  <tr>
    <td style="white-space: nowrap">pst</td>
    <td style="white-space: nowrap;text-align: right">2213.26 K</td>
    <td>&nbsp;</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">ets</td>
    <td style="white-space: nowrap; text-align: right">43.77 K</td>
    <td style="white-space: nowrap; text-align: right">50.56x</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">map</td>
    <td style="white-space: nowrap; text-align: right">41.16 K</td>
    <td style="white-space: nowrap; text-align: right">53.77x</td>
  </tr>

</table>



Memory Usage

<table style="width: 1%">
  <tr>
    <th>Name</th>
    <th style="text-align: right">Average</th>
    <th style="text-align: right">Factor</th>
  </tr>
  <tr>
    <td style="white-space: nowrap">pst</td>
    <td style="white-space: nowrap">584 B</td>
    <td>&nbsp;</td>
  </tr>
    <tr>
    <td style="white-space: nowrap">ets</td>
    <td style="white-space: nowrap">608 B</td>
    <td>1.04x</td>
  </tr>
    <tr>
    <td style="white-space: nowrap">map</td>
    <td style="white-space: nowrap">680 B</td>
    <td>1.16x</td>
  </tr>
</table>