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
    <td style="white-space: nowrap; text-align: right">2523.64</td>
    <td style="white-space: nowrap; text-align: right">0.40 ms</td>
    <td style="white-space: nowrap; text-align: right">±9.09%</td>
    <td style="white-space: nowrap; text-align: right">0.39 ms</td>
    <td style="white-space: nowrap; text-align: right">0.51 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap; text-align: right">104.74</td>
    <td style="white-space: nowrap; text-align: right">9.55 ms</td>
    <td style="white-space: nowrap; text-align: right">±4.35%</td>
    <td style="white-space: nowrap; text-align: right">9.39 ms</td>
    <td style="white-space: nowrap; text-align: right">11.11 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap; text-align: right">87.70</td>
    <td style="white-space: nowrap; text-align: right">11.40 ms</td>
    <td style="white-space: nowrap; text-align: right">±6.47%</td>
    <td style="white-space: nowrap; text-align: right">11.18 ms</td>
    <td style="white-space: nowrap; text-align: right">14.68 ms</td>
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
    <td style="white-space: nowrap;text-align: right">2523.64</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap; text-align: right">104.74</td>
    <td style="white-space: nowrap; text-align: right">24.1x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap; text-align: right">87.70</td>
    <td style="white-space: nowrap; text-align: right">28.77x</td>
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
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap">9.58 MB</td>
    <td>52.87x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap">13.42 MB</td>
    <td>74.07x</td>
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
    <td style="white-space: nowrap; text-align: right">2465.52</td>
    <td style="white-space: nowrap; text-align: right">0.41 ms</td>
    <td style="white-space: nowrap; text-align: right">±9.80%</td>
    <td style="white-space: nowrap; text-align: right">0.40 ms</td>
    <td style="white-space: nowrap; text-align: right">0.54 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap; text-align: right">103.36</td>
    <td style="white-space: nowrap; text-align: right">9.68 ms</td>
    <td style="white-space: nowrap; text-align: right">±5.28%</td>
    <td style="white-space: nowrap; text-align: right">9.47 ms</td>
    <td style="white-space: nowrap; text-align: right">11.37 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap; text-align: right">87.64</td>
    <td style="white-space: nowrap; text-align: right">11.41 ms</td>
    <td style="white-space: nowrap; text-align: right">±4.55%</td>
    <td style="white-space: nowrap; text-align: right">11.18 ms</td>
    <td style="white-space: nowrap; text-align: right">13.21 ms</td>
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
    <td style="white-space: nowrap;text-align: right">2465.52</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap; text-align: right">103.36</td>
    <td style="white-space: nowrap; text-align: right">23.85x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap; text-align: right">87.64</td>
    <td style="white-space: nowrap; text-align: right">28.13x</td>
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
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap">9.59 MB</td>
    <td>48.84x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap">13.43 MB</td>
    <td>68.38x</td>
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
    <td style="white-space: nowrap; text-align: right">2587.23</td>
    <td style="white-space: nowrap; text-align: right">0.39 ms</td>
    <td style="white-space: nowrap; text-align: right">±7.93%</td>
    <td style="white-space: nowrap; text-align: right">0.38 ms</td>
    <td style="white-space: nowrap; text-align: right">0.50 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap; text-align: right">104.25</td>
    <td style="white-space: nowrap; text-align: right">9.59 ms</td>
    <td style="white-space: nowrap; text-align: right">±5.03%</td>
    <td style="white-space: nowrap; text-align: right">9.42 ms</td>
    <td style="white-space: nowrap; text-align: right">11.37 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap; text-align: right">88.09</td>
    <td style="white-space: nowrap; text-align: right">11.35 ms</td>
    <td style="white-space: nowrap; text-align: right">±4.45%</td>
    <td style="white-space: nowrap; text-align: right">11.17 ms</td>
    <td style="white-space: nowrap; text-align: right">13.16 ms</td>
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
    <td style="white-space: nowrap;text-align: right">2587.23</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap; text-align: right">104.25</td>
    <td style="white-space: nowrap; text-align: right">24.82x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap; text-align: right">88.09</td>
    <td style="white-space: nowrap; text-align: right">29.37x</td>
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
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap">9.56 MB</td>
    <td>59.45x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap">13.40 MB</td>
    <td>83.33x</td>
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
    <td style="white-space: nowrap; text-align: right">145.64</td>
    <td style="white-space: nowrap; text-align: right">6.87 ms</td>
    <td style="white-space: nowrap; text-align: right">±6.70%</td>
    <td style="white-space: nowrap; text-align: right">6.69 ms</td>
    <td style="white-space: nowrap; text-align: right">8.59 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap; text-align: right">47.77</td>
    <td style="white-space: nowrap; text-align: right">20.93 ms</td>
    <td style="white-space: nowrap; text-align: right">±4.79%</td>
    <td style="white-space: nowrap; text-align: right">20.60 ms</td>
    <td style="white-space: nowrap; text-align: right">24.18 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap; text-align: right">43.05</td>
    <td style="white-space: nowrap; text-align: right">23.23 ms</td>
    <td style="white-space: nowrap; text-align: right">±7.41%</td>
    <td style="white-space: nowrap; text-align: right">22.63 ms</td>
    <td style="white-space: nowrap; text-align: right">29.32 ms</td>
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
    <td style="white-space: nowrap;text-align: right">145.64</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap; text-align: right">47.77</td>
    <td style="white-space: nowrap; text-align: right">3.05x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap; text-align: right">43.05</td>
    <td style="white-space: nowrap; text-align: right">3.38x</td>
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
    <td style="white-space: nowrap">1.89 MB</td>
      <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap">15.01 MB</td>
    <td>7.95x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap">10.37 MB</td>
    <td>5.49x</td>
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
    <td style="white-space: nowrap; text-align: right">111.29</td>
    <td style="white-space: nowrap; text-align: right">8.99 ms</td>
    <td style="white-space: nowrap; text-align: right">±4.59%</td>
    <td style="white-space: nowrap; text-align: right">8.83 ms</td>
    <td style="white-space: nowrap; text-align: right">10.54 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap; text-align: right">38.79</td>
    <td style="white-space: nowrap; text-align: right">25.78 ms</td>
    <td style="white-space: nowrap; text-align: right">±6.45%</td>
    <td style="white-space: nowrap; text-align: right">25.20 ms</td>
    <td style="white-space: nowrap; text-align: right">31.56 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap; text-align: right">35.12</td>
    <td style="white-space: nowrap; text-align: right">28.47 ms</td>
    <td style="white-space: nowrap; text-align: right">±3.71%</td>
    <td style="white-space: nowrap; text-align: right">28.13 ms</td>
    <td style="white-space: nowrap; text-align: right">32.51 ms</td>
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
    <td style="white-space: nowrap;text-align: right">111.29</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap; text-align: right">38.79</td>
    <td style="white-space: nowrap; text-align: right">2.87x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap; text-align: right">35.12</td>
    <td style="white-space: nowrap; text-align: right">3.17x</td>
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
    <td style="white-space: nowrap">2.49 MB</td>
      <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap">10.76 MB</td>
    <td>4.31x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap">14.81 MB</td>
    <td>5.94x</td>
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
    <td style="white-space: nowrap; text-align: right">2566.58</td>
    <td style="white-space: nowrap; text-align: right">0.39 ms</td>
    <td style="white-space: nowrap; text-align: right">±14.97%</td>
    <td style="white-space: nowrap; text-align: right">0.38 ms</td>
    <td style="white-space: nowrap; text-align: right">0.55 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap; text-align: right">146.04</td>
    <td style="white-space: nowrap; text-align: right">6.85 ms</td>
    <td style="white-space: nowrap; text-align: right">±6.06%</td>
    <td style="white-space: nowrap; text-align: right">6.73 ms</td>
    <td style="white-space: nowrap; text-align: right">8.35 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap; text-align: right">124.01</td>
    <td style="white-space: nowrap; text-align: right">8.06 ms</td>
    <td style="white-space: nowrap; text-align: right">±10.25%</td>
    <td style="white-space: nowrap; text-align: right">7.83 ms</td>
    <td style="white-space: nowrap; text-align: right">10.64 ms</td>
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
    <td style="white-space: nowrap;text-align: right">2566.58</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap; text-align: right">146.04</td>
    <td style="white-space: nowrap; text-align: right">17.57x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap; text-align: right">124.01</td>
    <td style="white-space: nowrap; text-align: right">20.7x</td>
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
    <td style="white-space: nowrap">0.168 MB</td>
      <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap">6.48 MB</td>
    <td>38.63x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap">4.44 MB</td>
    <td>26.48x</td>
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
    <td style="white-space: nowrap; text-align: right">528.16</td>
    <td style="white-space: nowrap; text-align: right">1.89 ms</td>
    <td style="white-space: nowrap; text-align: right">±13.41%</td>
    <td style="white-space: nowrap; text-align: right">1.85 ms</td>
    <td style="white-space: nowrap; text-align: right">2.43 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap; text-align: right">112.01</td>
    <td style="white-space: nowrap; text-align: right">8.93 ms</td>
    <td style="white-space: nowrap; text-align: right">±8.12%</td>
    <td style="white-space: nowrap; text-align: right">8.71 ms</td>
    <td style="white-space: nowrap; text-align: right">11.69 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap; text-align: right">97.24</td>
    <td style="white-space: nowrap; text-align: right">10.28 ms</td>
    <td style="white-space: nowrap; text-align: right">±8.93%</td>
    <td style="white-space: nowrap; text-align: right">10.02 ms</td>
    <td style="white-space: nowrap; text-align: right">13.41 ms</td>
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
    <td style="white-space: nowrap;text-align: right">528.16</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap; text-align: right">112.01</td>
    <td style="white-space: nowrap; text-align: right">4.72x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap; text-align: right">97.24</td>
    <td style="white-space: nowrap; text-align: right">5.43x</td>
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
    <td style="white-space: nowrap">0.54 MB</td>
      <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap">6.67 MB</td>
    <td>12.42x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap">4.76 MB</td>
    <td>8.85x</td>
  </tr>
</table>
<hr/>
