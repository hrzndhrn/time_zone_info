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
    <td style="white-space: nowrap; text-align: right">1385.36</td>
    <td style="white-space: nowrap; text-align: right">0.72 ms</td>
    <td style="white-space: nowrap; text-align: right">±13.93%</td>
    <td style="white-space: nowrap; text-align: right">0.69 ms</td>
    <td style="white-space: nowrap; text-align: right">1.02 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap; text-align: right">63.67</td>
    <td style="white-space: nowrap; text-align: right">15.71 ms</td>
    <td style="white-space: nowrap; text-align: right">±13.32%</td>
    <td style="white-space: nowrap; text-align: right">15.32 ms</td>
    <td style="white-space: nowrap; text-align: right">27.14 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap; text-align: right">54.67</td>
    <td style="white-space: nowrap; text-align: right">18.29 ms</td>
    <td style="white-space: nowrap; text-align: right">±14.41%</td>
    <td style="white-space: nowrap; text-align: right">17.82 ms</td>
    <td style="white-space: nowrap; text-align: right">32.58 ms</td>
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
    <td style="white-space: nowrap;text-align: right">1385.36</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap; text-align: right">63.67</td>
    <td style="white-space: nowrap; text-align: right">21.76x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap; text-align: right">54.67</td>
    <td style="white-space: nowrap; text-align: right">25.34x</td>
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
    <td style="white-space: nowrap; text-align: right">1365.64</td>
    <td style="white-space: nowrap; text-align: right">0.73 ms</td>
    <td style="white-space: nowrap; text-align: right">±23.61%</td>
    <td style="white-space: nowrap; text-align: right">0.71 ms</td>
    <td style="white-space: nowrap; text-align: right">1.00 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap; text-align: right">62.76</td>
    <td style="white-space: nowrap; text-align: right">15.93 ms</td>
    <td style="white-space: nowrap; text-align: right">±7.42%</td>
    <td style="white-space: nowrap; text-align: right">15.78 ms</td>
    <td style="white-space: nowrap; text-align: right">20.21 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap; text-align: right">52.79</td>
    <td style="white-space: nowrap; text-align: right">18.94 ms</td>
    <td style="white-space: nowrap; text-align: right">±23.18%</td>
    <td style="white-space: nowrap; text-align: right">17.83 ms</td>
    <td style="white-space: nowrap; text-align: right">44.65 ms</td>
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
    <td style="white-space: nowrap;text-align: right">1365.64</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap; text-align: right">62.76</td>
    <td style="white-space: nowrap; text-align: right">21.76x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap; text-align: right">52.79</td>
    <td style="white-space: nowrap; text-align: right">25.87x</td>
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
    <td style="white-space: nowrap; text-align: right">1404.38</td>
    <td style="white-space: nowrap; text-align: right">0.71 ms</td>
    <td style="white-space: nowrap; text-align: right">±18.02%</td>
    <td style="white-space: nowrap; text-align: right">0.69 ms</td>
    <td style="white-space: nowrap; text-align: right">1.05 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap; text-align: right">63.54</td>
    <td style="white-space: nowrap; text-align: right">15.74 ms</td>
    <td style="white-space: nowrap; text-align: right">±12.90%</td>
    <td style="white-space: nowrap; text-align: right">15.43 ms</td>
    <td style="white-space: nowrap; text-align: right">21.48 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap; text-align: right">56.06</td>
    <td style="white-space: nowrap; text-align: right">17.84 ms</td>
    <td style="white-space: nowrap; text-align: right">±12.31%</td>
    <td style="white-space: nowrap; text-align: right">17.53 ms</td>
    <td style="white-space: nowrap; text-align: right">27.00 ms</td>
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
    <td style="white-space: nowrap;text-align: right">1404.38</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap; text-align: right">63.54</td>
    <td style="white-space: nowrap; text-align: right">22.1x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap; text-align: right">56.06</td>
    <td style="white-space: nowrap; text-align: right">25.05x</td>
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
    <td style="white-space: nowrap; text-align: right">166.90</td>
    <td style="white-space: nowrap; text-align: right">5.99 ms</td>
    <td style="white-space: nowrap; text-align: right">±5.32%</td>
    <td style="white-space: nowrap; text-align: right">5.93 ms</td>
    <td style="white-space: nowrap; text-align: right">7.15 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap; text-align: right">40.98</td>
    <td style="white-space: nowrap; text-align: right">24.40 ms</td>
    <td style="white-space: nowrap; text-align: right">±3.36%</td>
    <td style="white-space: nowrap; text-align: right">24.17 ms</td>
    <td style="white-space: nowrap; text-align: right">27.20 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap; text-align: right">26.97</td>
    <td style="white-space: nowrap; text-align: right">37.08 ms</td>
    <td style="white-space: nowrap; text-align: right">±6.46%</td>
    <td style="white-space: nowrap; text-align: right">36.90 ms</td>
    <td style="white-space: nowrap; text-align: right">43.49 ms</td>
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
    <td style="white-space: nowrap;text-align: right">166.90</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap; text-align: right">40.98</td>
    <td style="white-space: nowrap; text-align: right">4.07x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap; text-align: right">26.97</td>
    <td style="white-space: nowrap; text-align: right">6.19x</td>
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
    <td style="white-space: nowrap">1.07 MB</td>
      <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap">15.88 MB</td>
    <td>14.78x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap">16.14 MB</td>
    <td>15.03x</td>
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
    <td style="white-space: nowrap; text-align: right">108.51</td>
    <td style="white-space: nowrap; text-align: right">9.22 ms</td>
    <td style="white-space: nowrap; text-align: right">±6.37%</td>
    <td style="white-space: nowrap; text-align: right">9.07 ms</td>
    <td style="white-space: nowrap; text-align: right">11.71 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap; text-align: right">34.76</td>
    <td style="white-space: nowrap; text-align: right">28.77 ms</td>
    <td style="white-space: nowrap; text-align: right">±7.96%</td>
    <td style="white-space: nowrap; text-align: right">28.20 ms</td>
    <td style="white-space: nowrap; text-align: right">36.45 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap; text-align: right">23.94</td>
    <td style="white-space: nowrap; text-align: right">41.78 ms</td>
    <td style="white-space: nowrap; text-align: right">±6.87%</td>
    <td style="white-space: nowrap; text-align: right">41.26 ms</td>
    <td style="white-space: nowrap; text-align: right">49.73 ms</td>
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
    <td style="white-space: nowrap;text-align: right">108.51</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap; text-align: right">34.76</td>
    <td style="white-space: nowrap; text-align: right">3.12x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap; text-align: right">23.94</td>
    <td style="white-space: nowrap; text-align: right">4.53x</td>
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
    <td style="white-space: nowrap">1.73 MB</td>
      <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap">16.10 MB</td>
    <td>9.33x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap">16.14 MB</td>
    <td>9.35x</td>
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
    <td style="white-space: nowrap; text-align: right">1609.22</td>
    <td style="white-space: nowrap; text-align: right">0.62 ms</td>
    <td style="white-space: nowrap; text-align: right">±11.09%</td>
    <td style="white-space: nowrap; text-align: right">0.60 ms</td>
    <td style="white-space: nowrap; text-align: right">0.85 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap; text-align: right">122.66</td>
    <td style="white-space: nowrap; text-align: right">8.15 ms</td>
    <td style="white-space: nowrap; text-align: right">±5.16%</td>
    <td style="white-space: nowrap; text-align: right">8.09 ms</td>
    <td style="white-space: nowrap; text-align: right">9.73 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap; text-align: right">71.23</td>
    <td style="white-space: nowrap; text-align: right">14.04 ms</td>
    <td style="white-space: nowrap; text-align: right">±7.17%</td>
    <td style="white-space: nowrap; text-align: right">13.96 ms</td>
    <td style="white-space: nowrap; text-align: right">18.34 ms</td>
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
    <td style="white-space: nowrap;text-align: right">1609.22</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap; text-align: right">122.66</td>
    <td style="white-space: nowrap; text-align: right">13.12x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap; text-align: right">71.23</td>
    <td style="white-space: nowrap; text-align: right">22.59x</td>
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
    <td style="white-space: nowrap">0.170 MB</td>
      <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap">6.49 MB</td>
    <td>38.24x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap">6.70 MB</td>
    <td>39.48x</td>
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
    <td style="white-space: nowrap; text-align: right">511.08</td>
    <td style="white-space: nowrap; text-align: right">1.96 ms</td>
    <td style="white-space: nowrap; text-align: right">±8.67%</td>
    <td style="white-space: nowrap; text-align: right">1.93 ms</td>
    <td style="white-space: nowrap; text-align: right">2.49 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap; text-align: right">69.08</td>
    <td style="white-space: nowrap; text-align: right">14.48 ms</td>
    <td style="white-space: nowrap; text-align: right">±5.72%</td>
    <td style="white-space: nowrap; text-align: right">14.32 ms</td>
    <td style="white-space: nowrap; text-align: right">18.09 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap; text-align: right">56.89</td>
    <td style="white-space: nowrap; text-align: right">17.58 ms</td>
    <td style="white-space: nowrap; text-align: right">±20.52%</td>
    <td style="white-space: nowrap; text-align: right">17.08 ms</td>
    <td style="white-space: nowrap; text-align: right">25.81 ms</td>
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
    <td style="white-space: nowrap;text-align: right">511.08</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap; text-align: right">69.08</td>
    <td style="white-space: nowrap; text-align: right">7.4x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap; text-align: right">56.89</td>
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
