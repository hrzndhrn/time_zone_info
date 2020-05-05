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
    <td style="white-space: nowrap">1.10.2</td>
  </tr><tr>
    <th style="white-space: nowrap">Erlang Version</th>
    <td style="white-space: nowrap">22.3</td>
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
    <td style="white-space: nowrap; text-align: right">2635.70</td>
    <td style="white-space: nowrap; text-align: right">0.38 ms</td>
    <td style="white-space: nowrap; text-align: right">±4.98%</td>
    <td style="white-space: nowrap; text-align: right">0.38 ms</td>
    <td style="white-space: nowrap; text-align: right">0.45 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap; text-align: right">375.31</td>
    <td style="white-space: nowrap; text-align: right">2.66 ms</td>
    <td style="white-space: nowrap; text-align: right">±2.60%</td>
    <td style="white-space: nowrap; text-align: right">2.64 ms</td>
    <td style="white-space: nowrap; text-align: right">2.97 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap; text-align: right">282.45</td>
    <td style="white-space: nowrap; text-align: right">3.54 ms</td>
    <td style="white-space: nowrap; text-align: right">±1.78%</td>
    <td style="white-space: nowrap; text-align: right">3.52 ms</td>
    <td style="white-space: nowrap; text-align: right">3.79 ms</td>
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
    <td style="white-space: nowrap;text-align: right">2635.70</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap; text-align: right">375.31</td>
    <td style="white-space: nowrap; text-align: right">7.02x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap; text-align: right">282.45</td>
    <td style="white-space: nowrap; text-align: right">9.33x</td>
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
    <td style="white-space: nowrap">0.176 MB</td>
      <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap">2.95 MB</td>
    <td>16.79x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap">2.99 MB</td>
    <td>16.97x</td>
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
    <td style="white-space: nowrap; text-align: right">547.02</td>
    <td style="white-space: nowrap; text-align: right">1.83 ms</td>
    <td style="white-space: nowrap; text-align: right">±4.19%</td>
    <td style="white-space: nowrap; text-align: right">1.83 ms</td>
    <td style="white-space: nowrap; text-align: right">2.07 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap; text-align: right">257.16</td>
    <td style="white-space: nowrap; text-align: right">3.89 ms</td>
    <td style="white-space: nowrap; text-align: right">±2.27%</td>
    <td style="white-space: nowrap; text-align: right">3.86 ms</td>
    <td style="white-space: nowrap; text-align: right">4.27 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap; text-align: right">195.12</td>
    <td style="white-space: nowrap; text-align: right">5.13 ms</td>
    <td style="white-space: nowrap; text-align: right">±2.19%</td>
    <td style="white-space: nowrap; text-align: right">5.10 ms</td>
    <td style="white-space: nowrap; text-align: right">5.64 ms</td>
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
    <td style="white-space: nowrap;text-align: right">547.02</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap; text-align: right">257.16</td>
    <td style="white-space: nowrap; text-align: right">2.13x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap; text-align: right">195.12</td>
    <td style="white-space: nowrap; text-align: right">2.8x</td>
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
    <td style="white-space: nowrap">0.71 MB</td>
      <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap">3.86 MB</td>
    <td>5.46x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap">2.88 MB</td>
    <td>4.08x</td>
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
    <td style="white-space: nowrap; text-align: right">2696.15</td>
    <td style="white-space: nowrap; text-align: right">0.37 ms</td>
    <td style="white-space: nowrap; text-align: right">±5.26%</td>
    <td style="white-space: nowrap; text-align: right">0.37 ms</td>
    <td style="white-space: nowrap; text-align: right">0.45 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap; text-align: right">377.23</td>
    <td style="white-space: nowrap; text-align: right">2.65 ms</td>
    <td style="white-space: nowrap; text-align: right">±2.14%</td>
    <td style="white-space: nowrap; text-align: right">2.63 ms</td>
    <td style="white-space: nowrap; text-align: right">2.91 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap; text-align: right">267.58</td>
    <td style="white-space: nowrap; text-align: right">3.74 ms</td>
    <td style="white-space: nowrap; text-align: right">±1.69%</td>
    <td style="white-space: nowrap; text-align: right">3.72 ms</td>
    <td style="white-space: nowrap; text-align: right">4.00 ms</td>
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
    <td style="white-space: nowrap;text-align: right">2696.15</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap; text-align: right">377.23</td>
    <td style="white-space: nowrap; text-align: right">7.15x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap; text-align: right">267.58</td>
    <td style="white-space: nowrap; text-align: right">10.08x</td>
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
    <td style="white-space: nowrap">0.158 MB</td>
      <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap">2.93 MB</td>
    <td>18.55x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap">2.97 MB</td>
    <td>18.76x</td>
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
    <td style="white-space: nowrap; text-align: right">550.55</td>
    <td style="white-space: nowrap; text-align: right">1.82 ms</td>
    <td style="white-space: nowrap; text-align: right">±3.21%</td>
    <td style="white-space: nowrap; text-align: right">1.81 ms</td>
    <td style="white-space: nowrap; text-align: right">2.06 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap; text-align: right">204.20</td>
    <td style="white-space: nowrap; text-align: right">4.90 ms</td>
    <td style="white-space: nowrap; text-align: right">±2.99%</td>
    <td style="white-space: nowrap; text-align: right">4.87 ms</td>
    <td style="white-space: nowrap; text-align: right">5.51 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap; text-align: right">155.55</td>
    <td style="white-space: nowrap; text-align: right">6.43 ms</td>
    <td style="white-space: nowrap; text-align: right">±4.05%</td>
    <td style="white-space: nowrap; text-align: right">6.36 ms</td>
    <td style="white-space: nowrap; text-align: right">7.79 ms</td>
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
    <td style="white-space: nowrap;text-align: right">550.55</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap; text-align: right">204.20</td>
    <td style="white-space: nowrap; text-align: right">2.7x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap; text-align: right">155.55</td>
    <td style="white-space: nowrap; text-align: right">3.54x</td>
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
    <td style="white-space: nowrap">0.55 MB</td>
      <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap">3.36 MB</td>
    <td>6.13x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap">3.37 MB</td>
    <td>6.14x</td>
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
    <td style="white-space: nowrap; text-align: right">245.26</td>
    <td style="white-space: nowrap; text-align: right">4.08 ms</td>
    <td style="white-space: nowrap; text-align: right">±2.15%</td>
    <td style="white-space: nowrap; text-align: right">4.06 ms</td>
    <td style="white-space: nowrap; text-align: right">4.44 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap; text-align: right">134.61</td>
    <td style="white-space: nowrap; text-align: right">7.43 ms</td>
    <td style="white-space: nowrap; text-align: right">±3.15%</td>
    <td style="white-space: nowrap; text-align: right">7.35 ms</td>
    <td style="white-space: nowrap; text-align: right">8.13 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap; text-align: right">107.57</td>
    <td style="white-space: nowrap; text-align: right">9.30 ms</td>
    <td style="white-space: nowrap; text-align: right">±3.55%</td>
    <td style="white-space: nowrap; text-align: right">9.21 ms</td>
    <td style="white-space: nowrap; text-align: right">10.65 ms</td>
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
    <td style="white-space: nowrap;text-align: right">245.26</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap; text-align: right">134.61</td>
    <td style="white-space: nowrap; text-align: right">1.82x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap; text-align: right">107.57</td>
    <td style="white-space: nowrap; text-align: right">2.28x</td>
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
    <td style="white-space: nowrap">1.15 MB</td>
      <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap">3.92 MB</td>
    <td>3.41x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap">4.08 MB</td>
    <td>3.56x</td>
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
    <td style="white-space: nowrap; text-align: right">2661.65</td>
    <td style="white-space: nowrap; text-align: right">0.38 ms</td>
    <td style="white-space: nowrap; text-align: right">±4.51%</td>
    <td style="white-space: nowrap; text-align: right">0.38 ms</td>
    <td style="white-space: nowrap; text-align: right">0.44 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap; text-align: right">617.39</td>
    <td style="white-space: nowrap; text-align: right">1.62 ms</td>
    <td style="white-space: nowrap; text-align: right">±3.08%</td>
    <td style="white-space: nowrap; text-align: right">1.60 ms</td>
    <td style="white-space: nowrap; text-align: right">1.80 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap; text-align: right">414.21</td>
    <td style="white-space: nowrap; text-align: right">2.41 ms</td>
    <td style="white-space: nowrap; text-align: right">±5.87%</td>
    <td style="white-space: nowrap; text-align: right">2.38 ms</td>
    <td style="white-space: nowrap; text-align: right">3.04 ms</td>
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
    <td style="white-space: nowrap;text-align: right">2661.65</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap; text-align: right">617.39</td>
    <td style="white-space: nowrap; text-align: right">4.31x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap; text-align: right">414.21</td>
    <td style="white-space: nowrap; text-align: right">6.43x</td>
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
    <td style="white-space: nowrap">0.165 MB</td>
      <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap">1.40 MB</td>
    <td>8.46x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap">1.41 MB</td>
    <td>8.54x</td>
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
    <td style="white-space: nowrap; text-align: right">1240.61</td>
    <td style="white-space: nowrap; text-align: right">0.81 ms</td>
    <td style="white-space: nowrap; text-align: right">±3.77%</td>
    <td style="white-space: nowrap; text-align: right">0.79 ms</td>
    <td style="white-space: nowrap; text-align: right">0.93 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap; text-align: right">446.00</td>
    <td style="white-space: nowrap; text-align: right">2.24 ms</td>
    <td style="white-space: nowrap; text-align: right">±3.46%</td>
    <td style="white-space: nowrap; text-align: right">2.22 ms</td>
    <td style="white-space: nowrap; text-align: right">2.53 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap; text-align: right">328.40</td>
    <td style="white-space: nowrap; text-align: right">3.05 ms</td>
    <td style="white-space: nowrap; text-align: right">±5.60%</td>
    <td style="white-space: nowrap; text-align: right">3.00 ms</td>
    <td style="white-space: nowrap; text-align: right">3.73 ms</td>
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
    <td style="white-space: nowrap;text-align: right">1240.61</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap; text-align: right">446.00</td>
    <td style="white-space: nowrap; text-align: right">2.78x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap; text-align: right">328.40</td>
    <td style="white-space: nowrap; text-align: right">3.78x</td>
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
    <td style="white-space: nowrap">0.24 MB</td>
      <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap">1.66 MB</td>
    <td>6.77x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap">1.74 MB</td>
    <td>7.11x</td>
  </tr>
</table>
<hr/>
