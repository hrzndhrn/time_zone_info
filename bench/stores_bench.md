# Benchmark

This benchmark compares the different `DataStores` available in
`TimeZoneInfo`.

The `TimeZoneInfo` will be tested in three different configurations.
Each version uses a different strategy to keep the data available.
- `time_zone_info_pst` is using
  [`:persistent_term`](https://erlang.org/doc/man/persistent_term.html)
- `time_zone_info_ets` is using `:ets`
  [(Erlang Term Storage)](https://erlang.org/doc/man/ets.html)
- `time_zone_info_map` is using a `GenServer` with a `Map` as state. This
  version isn't an available configuration in `TimeZoneInfo`. The
  `GenServer` version is otherwise only used in the tests.

The inputs for every benchmark run:
- **world_ok:** 333 `(datetime, time_zone)` arguments that are resulting in a
  `:ok` return value.
- **world_gap:** 333 `(datetime, time_zone)` arguments that are resulting in a
  `:gap` return tuple.
- **world_ambiguous:** 333 `(datetime, time_zone)` arguments that are resulting in
  a `:ambiguous` return tuple.
- **world_last_year:** 333 `(datetime, time_zone)` arguments with random time zone
  and a date time from now to one year in the past. The data is calculated
  once for all test candidates.
- **berlin_gap_2020**: 333 gaps in the time zone `Europe/Berlin` in 2020.
- **berlin_ambiguous_2020**: 333 ambiguous date time in the time zone
  `Europe/Berlin` in 2020.

The inputs **ok**, **gap**, and **ambiguous** containing random time zones
and date times between 1900 and 2050.

## System

Benchmark suite executing on the following system:

<table style="width: 1%">
  <tr>
    <th style="width: 1%; white-space: nowrap">Operating System</th>
    <td>macOS</td>
  </tr><tr>
    <th style="white-space: nowrap">CPU Information</th>
    <td style="white-space: nowrap">Intel(R) Core(TM) i7-4770HQ CPU @ 2.20GHz</td>
  </tr><tr>
    <th style="white-space: nowrap">Number of Available Cores</th>
    <td style="white-space: nowrap">8</td>
  </tr><tr>
    <th style="white-space: nowrap">Available Memory</th>
    <td style="white-space: nowrap">16 GB</td>
  </tr><tr>
    <th style="white-space: nowrap">Elixir Version</th>
    <td style="white-space: nowrap">1.10.3</td>
  </tr><tr>
    <th style="white-space: nowrap">Erlang Version</th>
    <td style="white-space: nowrap">23.0</td>
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


__Input: berlin_ambiguous_2020__

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
    <td style="white-space: nowrap">time_zone_info_pst</td>
    <td style="white-space: nowrap; text-align: right">1337.41</td>
    <td style="white-space: nowrap; text-align: right">0.75 ms</td>
    <td style="white-space: nowrap; text-align: right">±12.75%</td>
    <td style="white-space: nowrap; text-align: right">0.72 ms</td>
    <td style="white-space: nowrap; text-align: right">1.09 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap; text-align: right">64.79</td>
    <td style="white-space: nowrap; text-align: right">15.43 ms</td>
    <td style="white-space: nowrap; text-align: right">±5.08%</td>
    <td style="white-space: nowrap; text-align: right">15.26 ms</td>
    <td style="white-space: nowrap; text-align: right">18.07 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap; text-align: right">56.86</td>
    <td style="white-space: nowrap; text-align: right">17.59 ms</td>
    <td style="white-space: nowrap; text-align: right">±4.82%</td>
    <td style="white-space: nowrap; text-align: right">17.31 ms</td>
    <td style="white-space: nowrap; text-align: right">21.45 ms</td>
  </tr>
</table>
Comparison
<table style="width: 1%">
  <tr>
    <th>Name</th>
    <th style="text-align: right">IPS</th>
    <th style="text-align: right">Slower</th>
  <tr>
    <td style="white-space: nowrap">time_zone_info_pst</td>
    <td style="white-space: nowrap;text-align: right">1337.41</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap; text-align: right">64.79</td>
    <td style="white-space: nowrap; text-align: right">20.64x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap; text-align: right">56.86</td>
    <td style="white-space: nowrap; text-align: right">23.52x</td>
  </tr>
</table>
Memory Usage
<table style="width: 1%">
  <tr>
    <th>Name</th>
    <th style="text-align: right">Memory</th>
      <th style="text-align: right">Factor</th>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_pst</td>
    <td style="white-space: nowrap">0.181 MB</td>
      <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap">15.65 MB</td>
    <td>86.35x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap">15.68 MB</td>
    <td>86.52x</td>
  </tr>
</table>
<hr/>

__Input: berlin_gap_2020__

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
    <td style="white-space: nowrap">time_zone_info_pst</td>
    <td style="white-space: nowrap; text-align: right">1317.15</td>
    <td style="white-space: nowrap; text-align: right">0.76 ms</td>
    <td style="white-space: nowrap; text-align: right">±14.03%</td>
    <td style="white-space: nowrap; text-align: right">0.73 ms</td>
    <td style="white-space: nowrap; text-align: right">1.17 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap; text-align: right">61.97</td>
    <td style="white-space: nowrap; text-align: right">16.14 ms</td>
    <td style="white-space: nowrap; text-align: right">±9.67%</td>
    <td style="white-space: nowrap; text-align: right">15.90 ms</td>
    <td style="white-space: nowrap; text-align: right">22.74 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap; text-align: right">53.34</td>
    <td style="white-space: nowrap; text-align: right">18.75 ms</td>
    <td style="white-space: nowrap; text-align: right">±21.97%</td>
    <td style="white-space: nowrap; text-align: right">17.58 ms</td>
    <td style="white-space: nowrap; text-align: right">35.48 ms</td>
  </tr>
</table>
Comparison
<table style="width: 1%">
  <tr>
    <th>Name</th>
    <th style="text-align: right">IPS</th>
    <th style="text-align: right">Slower</th>
  <tr>
    <td style="white-space: nowrap">time_zone_info_pst</td>
    <td style="white-space: nowrap;text-align: right">1317.15</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap; text-align: right">61.97</td>
    <td style="white-space: nowrap; text-align: right">21.25x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap; text-align: right">53.34</td>
    <td style="white-space: nowrap; text-align: right">24.69x</td>
  </tr>
</table>
Memory Usage
<table style="width: 1%">
  <tr>
    <th>Name</th>
    <th style="text-align: right">Memory</th>
      <th style="text-align: right">Factor</th>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_pst</td>
    <td style="white-space: nowrap">0.196 MB</td>
      <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap">15.66 MB</td>
    <td>79.71x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap">15.69 MB</td>
    <td>79.86x</td>
  </tr>
</table>
<hr/>

__Input: berlin_ok_2020__

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
    <td style="white-space: nowrap">time_zone_info_pst</td>
    <td style="white-space: nowrap; text-align: right">1347.62</td>
    <td style="white-space: nowrap; text-align: right">0.74 ms</td>
    <td style="white-space: nowrap; text-align: right">±16.54%</td>
    <td style="white-space: nowrap; text-align: right">0.71 ms</td>
    <td style="white-space: nowrap; text-align: right">1.14 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap; text-align: right">63.74</td>
    <td style="white-space: nowrap; text-align: right">15.69 ms</td>
    <td style="white-space: nowrap; text-align: right">±6.65%</td>
    <td style="white-space: nowrap; text-align: right">15.52 ms</td>
    <td style="white-space: nowrap; text-align: right">18.73 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap; text-align: right">56.17</td>
    <td style="white-space: nowrap; text-align: right">17.80 ms</td>
    <td style="white-space: nowrap; text-align: right">±6.90%</td>
    <td style="white-space: nowrap; text-align: right">17.47 ms</td>
    <td style="white-space: nowrap; text-align: right">22.99 ms</td>
  </tr>
</table>
Comparison
<table style="width: 1%">
  <tr>
    <th>Name</th>
    <th style="text-align: right">IPS</th>
    <th style="text-align: right">Slower</th>
  <tr>
    <td style="white-space: nowrap">time_zone_info_pst</td>
    <td style="white-space: nowrap;text-align: right">1347.62</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap; text-align: right">63.74</td>
    <td style="white-space: nowrap; text-align: right">21.14x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap; text-align: right">56.17</td>
    <td style="white-space: nowrap; text-align: right">23.99x</td>
  </tr>
</table>
Memory Usage
<table style="width: 1%">
  <tr>
    <th>Name</th>
    <th style="text-align: right">Memory</th>
      <th style="text-align: right">Factor</th>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_pst</td>
    <td style="white-space: nowrap">0.161 MB</td>
      <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap">15.62 MB</td>
    <td>97.17x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap">15.66 MB</td>
    <td>97.36x</td>
  </tr>
</table>
<hr/>

__Input: world_ambiguous__

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
    <td style="white-space: nowrap">time_zone_info_pst</td>
    <td style="white-space: nowrap; text-align: right">163.72</td>
    <td style="white-space: nowrap; text-align: right">6.11 ms</td>
    <td style="white-space: nowrap; text-align: right">±8.13%</td>
    <td style="white-space: nowrap; text-align: right">6.01 ms</td>
    <td style="white-space: nowrap; text-align: right">7.69 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap; text-align: right">40.16</td>
    <td style="white-space: nowrap; text-align: right">24.90 ms</td>
    <td style="white-space: nowrap; text-align: right">±6.41%</td>
    <td style="white-space: nowrap; text-align: right">24.55 ms</td>
    <td style="white-space: nowrap; text-align: right">32.02 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap; text-align: right">26.73</td>
    <td style="white-space: nowrap; text-align: right">37.41 ms</td>
    <td style="white-space: nowrap; text-align: right">±5.46%</td>
    <td style="white-space: nowrap; text-align: right">36.88 ms</td>
    <td style="white-space: nowrap; text-align: right">45.33 ms</td>
  </tr>
</table>
Comparison
<table style="width: 1%">
  <tr>
    <th>Name</th>
    <th style="text-align: right">IPS</th>
    <th style="text-align: right">Slower</th>
  <tr>
    <td style="white-space: nowrap">time_zone_info_pst</td>
    <td style="white-space: nowrap;text-align: right">163.72</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap; text-align: right">40.16</td>
    <td style="white-space: nowrap; text-align: right">4.08x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap; text-align: right">26.73</td>
    <td style="white-space: nowrap; text-align: right">6.12x</td>
  </tr>
</table>
Memory Usage
<table style="width: 1%">
  <tr>
    <th>Name</th>
    <th style="text-align: right">Memory</th>
      <th style="text-align: right">Factor</th>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_pst</td>
    <td style="white-space: nowrap">1.09 MB</td>
      <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap">15.97 MB</td>
    <td>14.62x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap">16.27 MB</td>
    <td>14.89x</td>
  </tr>
</table>
<hr/>

__Input: world_gap__

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
    <td style="white-space: nowrap">time_zone_info_pst</td>
    <td style="white-space: nowrap; text-align: right">102.02</td>
    <td style="white-space: nowrap; text-align: right">9.80 ms</td>
    <td style="white-space: nowrap; text-align: right">±5.78%</td>
    <td style="white-space: nowrap; text-align: right">9.63 ms</td>
    <td style="white-space: nowrap; text-align: right">12.13 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap; text-align: right">35.13</td>
    <td style="white-space: nowrap; text-align: right">28.47 ms</td>
    <td style="white-space: nowrap; text-align: right">±4.61%</td>
    <td style="white-space: nowrap; text-align: right">28.03 ms</td>
    <td style="white-space: nowrap; text-align: right">33.80 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap; text-align: right">23.44</td>
    <td style="white-space: nowrap; text-align: right">42.66 ms</td>
    <td style="white-space: nowrap; text-align: right">±8.62%</td>
    <td style="white-space: nowrap; text-align: right">41.70 ms</td>
    <td style="white-space: nowrap; text-align: right">59.92 ms</td>
  </tr>
</table>
Comparison
<table style="width: 1%">
  <tr>
    <th>Name</th>
    <th style="text-align: right">IPS</th>
    <th style="text-align: right">Slower</th>
  <tr>
    <td style="white-space: nowrap">time_zone_info_pst</td>
    <td style="white-space: nowrap;text-align: right">102.02</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap; text-align: right">35.13</td>
    <td style="white-space: nowrap; text-align: right">2.9x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap; text-align: right">23.44</td>
    <td style="white-space: nowrap; text-align: right">4.35x</td>
  </tr>
</table>
Memory Usage
<table style="width: 1%">
  <tr>
    <th>Name</th>
    <th style="text-align: right">Memory</th>
      <th style="text-align: right">Factor</th>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_pst</td>
    <td style="white-space: nowrap">1.74 MB</td>
      <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap">16.23 MB</td>
    <td>9.3x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap">16.26 MB</td>
    <td>9.32x</td>
  </tr>
</table>
<hr/>

__Input: world_last_year__

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
    <td style="white-space: nowrap">time_zone_info_pst</td>
    <td style="white-space: nowrap; text-align: right">1518.37</td>
    <td style="white-space: nowrap; text-align: right">0.66 ms</td>
    <td style="white-space: nowrap; text-align: right">±15.87%</td>
    <td style="white-space: nowrap; text-align: right">0.63 ms</td>
    <td style="white-space: nowrap; text-align: right">1.06 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap; text-align: right">109.67</td>
    <td style="white-space: nowrap; text-align: right">9.12 ms</td>
    <td style="white-space: nowrap; text-align: right">±7.78%</td>
    <td style="white-space: nowrap; text-align: right">8.97 ms</td>
    <td style="white-space: nowrap; text-align: right">11.41 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap; text-align: right">65.19</td>
    <td style="white-space: nowrap; text-align: right">15.34 ms</td>
    <td style="white-space: nowrap; text-align: right">±8.68%</td>
    <td style="white-space: nowrap; text-align: right">15.02 ms</td>
    <td style="white-space: nowrap; text-align: right">21.08 ms</td>
  </tr>
</table>
Comparison
<table style="width: 1%">
  <tr>
    <th>Name</th>
    <th style="text-align: right">IPS</th>
    <th style="text-align: right">Slower</th>
  <tr>
    <td style="white-space: nowrap">time_zone_info_pst</td>
    <td style="white-space: nowrap;text-align: right">1518.37</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap; text-align: right">109.67</td>
    <td style="white-space: nowrap; text-align: right">13.84x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap; text-align: right">65.19</td>
    <td style="white-space: nowrap; text-align: right">23.29x</td>
  </tr>
</table>
Memory Usage
<table style="width: 1%">
  <tr>
    <th>Name</th>
    <th style="text-align: right">Memory</th>
      <th style="text-align: right">Factor</th>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_pst</td>
    <td style="white-space: nowrap">0.172 MB</td>
      <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap">7.15 MB</td>
    <td>41.59x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap">7.00 MB</td>
    <td>40.71x</td>
  </tr>
</table>
<hr/>

__Input: world_ok__

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
    <td style="white-space: nowrap">time_zone_info_pst</td>
    <td style="white-space: nowrap; text-align: right">504.63</td>
    <td style="white-space: nowrap; text-align: right">1.98 ms</td>
    <td style="white-space: nowrap; text-align: right">±7.97%</td>
    <td style="white-space: nowrap; text-align: right">1.95 ms</td>
    <td style="white-space: nowrap; text-align: right">2.55 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap; text-align: right">68.56</td>
    <td style="white-space: nowrap; text-align: right">14.58 ms</td>
    <td style="white-space: nowrap; text-align: right">±6.61%</td>
    <td style="white-space: nowrap; text-align: right">14.37 ms</td>
    <td style="white-space: nowrap; text-align: right">18.60 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap; text-align: right">56.18</td>
    <td style="white-space: nowrap; text-align: right">17.80 ms</td>
    <td style="white-space: nowrap; text-align: right">±11.32%</td>
    <td style="white-space: nowrap; text-align: right">17.26 ms</td>
    <td style="white-space: nowrap; text-align: right">26.64 ms</td>
  </tr>
</table>
Comparison
<table style="width: 1%">
  <tr>
    <th>Name</th>
    <th style="text-align: right">IPS</th>
    <th style="text-align: right">Slower</th>
  <tr>
    <td style="white-space: nowrap">time_zone_info_pst</td>
    <td style="white-space: nowrap;text-align: right">504.63</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap; text-align: right">68.56</td>
    <td style="white-space: nowrap; text-align: right">7.36x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap; text-align: right">56.18</td>
    <td style="white-space: nowrap; text-align: right">8.98x</td>
  </tr>
</table>
Memory Usage
<table style="width: 1%">
  <tr>
    <th>Name</th>
    <th style="text-align: right">Memory</th>
      <th style="text-align: right">Factor</th>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_pst</td>
    <td style="white-space: nowrap">0.37 MB</td>
      <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap">7.19 MB</td>
    <td>19.41x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap">7.22 MB</td>
    <td>19.49x</td>
  </tr>
</table>
<hr/>
