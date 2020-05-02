# Benchmark

This benchmark compares `TimeZoneInfo` with
[`Tzdata`](https://github.com/lau/tzdata) and
[`Tz`](https://github.com/mathieuprog/tz).

The `TimeZoneInfo` will be tested in three different configurations.
Each version uses a different strategy to keep the data available.
- `time_zone_info_pst` is using
  [`:persistent_term`](https://erlang.org/doc/man/persistent_term.html)
- `time_zone_info_ets` is using `:ets`
  [(Erlang Term Storage)](https://erlang.org/doc/man/ets.html)
- `time_zone_info_map` is using a `GenServer` with a `Map` as state. This
  version isn't an available configuration in `TimeZoneInfo`. The
  `GenServer` version is otherwise only used in the tests.

All testees have an implementation for `TimeZoneDatabas`. For the benchmark,
each of them calls the function
`TimeZoneDatabase.time_zone_periods_from_wall_datetime/2`.

The inputs for every benchmark run:
- **ok:** 333 `(datetime, time_zone)` arguments that are resulting in a
  `:ok` return value.
- **gap:** 333 `(datetime, time_zone)` arguments that are resulting in a
  `:gap` return tuple.
- **ambiguous:** 333 `(datetime, time_zone)` arguments that are resulting in
  a `:ambiguous` return tuple.
- **last_year:** 333 `(datetime, time_zone)` arguments with random time zone
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


__Input: ambiguous__

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
    <td style="white-space: nowrap; text-align: right">395.13</td>
    <td style="white-space: nowrap; text-align: right">2.53 ms</td>
    <td style="white-space: nowrap; text-align: right">±8.39%</td>
    <td style="white-space: nowrap; text-align: right">2.46 ms</td>
    <td style="white-space: nowrap; text-align: right">3.29 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap; text-align: right">182.94</td>
    <td style="white-space: nowrap; text-align: right">5.47 ms</td>
    <td style="white-space: nowrap; text-align: right">±9.08%</td>
    <td style="white-space: nowrap; text-align: right">5.27 ms</td>
    <td style="white-space: nowrap; text-align: right">7.50 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap; text-align: right">134.08</td>
    <td style="white-space: nowrap; text-align: right">7.46 ms</td>
    <td style="white-space: nowrap; text-align: right">±9.22%</td>
    <td style="white-space: nowrap; text-align: right">7.21 ms</td>
    <td style="white-space: nowrap; text-align: right">10.36 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap; text-align: right">103.05</td>
    <td style="white-space: nowrap; text-align: right">9.70 ms</td>
    <td style="white-space: nowrap; text-align: right">±12.29%</td>
    <td style="white-space: nowrap; text-align: right">9.45 ms</td>
    <td style="white-space: nowrap; text-align: right">14.58 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">84.28</td>
    <td style="white-space: nowrap; text-align: right">11.87 ms</td>
    <td style="white-space: nowrap; text-align: right">±16.35%</td>
    <td style="white-space: nowrap; text-align: right">11.46 ms</td>
    <td style="white-space: nowrap; text-align: right">22.97 ms</td>
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
    <td style="white-space: nowrap;text-align: right">395.13</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap; text-align: right">182.94</td>
    <td style="white-space: nowrap; text-align: right">2.16x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap; text-align: right">134.08</td>
    <td style="white-space: nowrap; text-align: right">2.95x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap; text-align: right">103.05</td>
    <td style="white-space: nowrap; text-align: right">3.83x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">84.28</td>
    <td style="white-space: nowrap; text-align: right">4.69x</td>
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
    <td style="white-space: nowrap">0.94 MB</td>
      <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap">3.78 MB</td>
    <td>4.01x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap">3.84 MB</td>
    <td>4.07x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap">2.85 MB</td>
    <td>3.03x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap">2.31 MB</td>
    <td>2.45x</td>
  </tr>
</table>
<hr/>

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
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap; text-align: right">1957.72</td>
    <td style="white-space: nowrap; text-align: right">0.51 ms</td>
    <td style="white-space: nowrap; text-align: right">±9.45%</td>
    <td style="white-space: nowrap; text-align: right">0.50 ms</td>
    <td style="white-space: nowrap; text-align: right">0.68 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_pst</td>
    <td style="white-space: nowrap; text-align: right">1790.68</td>
    <td style="white-space: nowrap; text-align: right">0.56 ms</td>
    <td style="white-space: nowrap; text-align: right">±13.93%</td>
    <td style="white-space: nowrap; text-align: right">0.53 ms</td>
    <td style="white-space: nowrap; text-align: right">0.81 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap; text-align: right">345.10</td>
    <td style="white-space: nowrap; text-align: right">2.90 ms</td>
    <td style="white-space: nowrap; text-align: right">±5.01%</td>
    <td style="white-space: nowrap; text-align: right">2.84 ms</td>
    <td style="white-space: nowrap; text-align: right">3.51 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap; text-align: right">247.43</td>
    <td style="white-space: nowrap; text-align: right">4.04 ms</td>
    <td style="white-space: nowrap; text-align: right">±5.14%</td>
    <td style="white-space: nowrap; text-align: right">3.97 ms</td>
    <td style="white-space: nowrap; text-align: right">4.73 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">72.93</td>
    <td style="white-space: nowrap; text-align: right">13.71 ms</td>
    <td style="white-space: nowrap; text-align: right">±12.25%</td>
    <td style="white-space: nowrap; text-align: right">13.14 ms</td>
    <td style="white-space: nowrap; text-align: right">21.25 ms</td>
  </tr>
</table>
Comparison
<table style="width: 1%">
  <tr>
    <th>Name</th>
    <th style="text-align: right">IPS</th>
    <th style="text-align: right">Slower</th>
  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap;text-align: right">1957.72</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_pst</td>
    <td style="white-space: nowrap; text-align: right">1790.68</td>
    <td style="white-space: nowrap; text-align: right">1.09x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap; text-align: right">345.10</td>
    <td style="white-space: nowrap; text-align: right">5.67x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap; text-align: right">247.43</td>
    <td style="white-space: nowrap; text-align: right">7.91x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">72.93</td>
    <td style="white-space: nowrap; text-align: right">26.84x</td>
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
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap">0.107 MB</td>
      <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_pst</td>
    <td style="white-space: nowrap">0.31 MB</td>
    <td>2.91x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap">3.09 MB</td>
    <td>28.85x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap">3.12 MB</td>
    <td>29.16x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap">1.72 MB</td>
    <td>16.1x</td>
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
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap; text-align: right">1873.38</td>
    <td style="white-space: nowrap; text-align: right">0.53 ms</td>
    <td style="white-space: nowrap; text-align: right">±15.25%</td>
    <td style="white-space: nowrap; text-align: right">0.51 ms</td>
    <td style="white-space: nowrap; text-align: right">0.87 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_pst</td>
    <td style="white-space: nowrap; text-align: right">497.55</td>
    <td style="white-space: nowrap; text-align: right">2.01 ms</td>
    <td style="white-space: nowrap; text-align: right">±12.35%</td>
    <td style="white-space: nowrap; text-align: right">1.94 ms</td>
    <td style="white-space: nowrap; text-align: right">3.03 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap; text-align: right">236.06</td>
    <td style="white-space: nowrap; text-align: right">4.24 ms</td>
    <td style="white-space: nowrap; text-align: right">±5.61%</td>
    <td style="white-space: nowrap; text-align: right">4.14 ms</td>
    <td style="white-space: nowrap; text-align: right">5.15 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap; text-align: right">185.15</td>
    <td style="white-space: nowrap; text-align: right">5.40 ms</td>
    <td style="white-space: nowrap; text-align: right">±5.86%</td>
    <td style="white-space: nowrap; text-align: right">5.30 ms</td>
    <td style="white-space: nowrap; text-align: right">6.63 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">14.39</td>
    <td style="white-space: nowrap; text-align: right">69.51 ms</td>
    <td style="white-space: nowrap; text-align: right">±6.36%</td>
    <td style="white-space: nowrap; text-align: right">69.23 ms</td>
    <td style="white-space: nowrap; text-align: right">85.39 ms</td>
  </tr>
</table>
Comparison
<table style="width: 1%">
  <tr>
    <th>Name</th>
    <th style="text-align: right">IPS</th>
    <th style="text-align: right">Slower</th>
  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap;text-align: right">1873.38</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_pst</td>
    <td style="white-space: nowrap; text-align: right">497.55</td>
    <td style="white-space: nowrap; text-align: right">3.77x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap; text-align: right">236.06</td>
    <td style="white-space: nowrap; text-align: right">7.94x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap; text-align: right">185.15</td>
    <td style="white-space: nowrap; text-align: right">10.12x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">14.39</td>
    <td style="white-space: nowrap; text-align: right">130.21x</td>
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
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap">0.117 MB</td>
      <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_pst</td>
    <td style="white-space: nowrap">0.85 MB</td>
    <td>7.24x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap">3.32 MB</td>
    <td>28.29x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap">3.35 MB</td>
    <td>28.56x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap">46.26 MB</td>
    <td>394.62x</td>
  </tr>
</table>
<hr/>

__Input: gap__

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
    <td style="white-space: nowrap; text-align: right">207.63</td>
    <td style="white-space: nowrap; text-align: right">4.82 ms</td>
    <td style="white-space: nowrap; text-align: right">±6.86%</td>
    <td style="white-space: nowrap; text-align: right">4.69 ms</td>
    <td style="white-space: nowrap; text-align: right">6.14 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap; text-align: right">126.00</td>
    <td style="white-space: nowrap; text-align: right">7.94 ms</td>
    <td style="white-space: nowrap; text-align: right">±8.25%</td>
    <td style="white-space: nowrap; text-align: right">7.70 ms</td>
    <td style="white-space: nowrap; text-align: right">10.11 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap; text-align: right">97.62</td>
    <td style="white-space: nowrap; text-align: right">10.24 ms</td>
    <td style="white-space: nowrap; text-align: right">±8.87%</td>
    <td style="white-space: nowrap; text-align: right">9.88 ms</td>
    <td style="white-space: nowrap; text-align: right">13.39 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap; text-align: right">83.11</td>
    <td style="white-space: nowrap; text-align: right">12.03 ms</td>
    <td style="white-space: nowrap; text-align: right">±6.80%</td>
    <td style="white-space: nowrap; text-align: right">11.69 ms</td>
    <td style="white-space: nowrap; text-align: right">14.58 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">16.07</td>
    <td style="white-space: nowrap; text-align: right">62.21 ms</td>
    <td style="white-space: nowrap; text-align: right">±4.83%</td>
    <td style="white-space: nowrap; text-align: right">60.92 ms</td>
    <td style="white-space: nowrap; text-align: right">73.95 ms</td>
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
    <td style="white-space: nowrap;text-align: right">207.63</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap; text-align: right">126.00</td>
    <td style="white-space: nowrap; text-align: right">1.65x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap; text-align: right">97.62</td>
    <td style="white-space: nowrap; text-align: right">2.13x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap; text-align: right">83.11</td>
    <td style="white-space: nowrap; text-align: right">2.5x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">16.07</td>
    <td style="white-space: nowrap; text-align: right">12.92x</td>
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
    <td style="white-space: nowrap">1.44 MB</td>
      <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap">4.24 MB</td>
    <td>2.95x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap">4.32 MB</td>
    <td>3.0x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap">3.73 MB</td>
    <td>2.59x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap">43.95 MB</td>
    <td>30.57x</td>
  </tr>
</table>
<hr/>

__Input: last_year__

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
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap; text-align: right">2027.57</td>
    <td style="white-space: nowrap; text-align: right">0.49 ms</td>
    <td style="white-space: nowrap; text-align: right">±14.66%</td>
    <td style="white-space: nowrap; text-align: right">0.48 ms</td>
    <td style="white-space: nowrap; text-align: right">0.73 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_pst</td>
    <td style="white-space: nowrap; text-align: right">1961.15</td>
    <td style="white-space: nowrap; text-align: right">0.51 ms</td>
    <td style="white-space: nowrap; text-align: right">±12.51%</td>
    <td style="white-space: nowrap; text-align: right">0.49 ms</td>
    <td style="white-space: nowrap; text-align: right">0.72 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap; text-align: right">503.22</td>
    <td style="white-space: nowrap; text-align: right">1.99 ms</td>
    <td style="white-space: nowrap; text-align: right">±12.36%</td>
    <td style="white-space: nowrap; text-align: right">1.92 ms</td>
    <td style="white-space: nowrap; text-align: right">2.96 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap; text-align: right">373.06</td>
    <td style="white-space: nowrap; text-align: right">2.68 ms</td>
    <td style="white-space: nowrap; text-align: right">±10.36%</td>
    <td style="white-space: nowrap; text-align: right">2.57 ms</td>
    <td style="white-space: nowrap; text-align: right">3.81 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">182.54</td>
    <td style="white-space: nowrap; text-align: right">5.48 ms</td>
    <td style="white-space: nowrap; text-align: right">±11.31%</td>
    <td style="white-space: nowrap; text-align: right">5.34 ms</td>
    <td style="white-space: nowrap; text-align: right">8.12 ms</td>
  </tr>
</table>
Comparison
<table style="width: 1%">
  <tr>
    <th>Name</th>
    <th style="text-align: right">IPS</th>
    <th style="text-align: right">Slower</th>
  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap;text-align: right">2027.57</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_pst</td>
    <td style="white-space: nowrap; text-align: right">1961.15</td>
    <td style="white-space: nowrap; text-align: right">1.03x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap; text-align: right">503.22</td>
    <td style="white-space: nowrap; text-align: right">4.03x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap; text-align: right">373.06</td>
    <td style="white-space: nowrap; text-align: right">5.43x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">182.54</td>
    <td style="white-space: nowrap; text-align: right">11.11x</td>
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
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap">0.103 MB</td>
      <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_pst</td>
    <td style="white-space: nowrap">0.26 MB</td>
    <td>2.53x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap">1.54 MB</td>
    <td>14.98x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap">1.56 MB</td>
    <td>15.17x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap">1.37 MB</td>
    <td>13.29x</td>
  </tr>
</table>
<hr/>

__Input: ok__

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
    <td style="white-space: nowrap; text-align: right">804.16</td>
    <td style="white-space: nowrap; text-align: right">1.24 ms</td>
    <td style="white-space: nowrap; text-align: right">±10.35%</td>
    <td style="white-space: nowrap; text-align: right">1.20 ms</td>
    <td style="white-space: nowrap; text-align: right">1.71 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap; text-align: right">389.63</td>
    <td style="white-space: nowrap; text-align: right">2.57 ms</td>
    <td style="white-space: nowrap; text-align: right">±24.62%</td>
    <td style="white-space: nowrap; text-align: right">2.41 ms</td>
    <td style="white-space: nowrap; text-align: right">4.29 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap; text-align: right">291.73</td>
    <td style="white-space: nowrap; text-align: right">3.43 ms</td>
    <td style="white-space: nowrap; text-align: right">±13.63%</td>
    <td style="white-space: nowrap; text-align: right">3.32 ms</td>
    <td style="white-space: nowrap; text-align: right">5.32 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap; text-align: right">270.96</td>
    <td style="white-space: nowrap; text-align: right">3.69 ms</td>
    <td style="white-space: nowrap; text-align: right">±12.29%</td>
    <td style="white-space: nowrap; text-align: right">3.52 ms</td>
    <td style="white-space: nowrap; text-align: right">5.51 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">184.87</td>
    <td style="white-space: nowrap; text-align: right">5.41 ms</td>
    <td style="white-space: nowrap; text-align: right">±7.43%</td>
    <td style="white-space: nowrap; text-align: right">5.25 ms</td>
    <td style="white-space: nowrap; text-align: right">6.77 ms</td>
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
    <td style="white-space: nowrap;text-align: right">804.16</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap; text-align: right">389.63</td>
    <td style="white-space: nowrap; text-align: right">2.06x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap; text-align: right">291.73</td>
    <td style="white-space: nowrap; text-align: right">2.76x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap; text-align: right">270.96</td>
    <td style="white-space: nowrap; text-align: right">2.97x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">184.87</td>
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
    <td style="white-space: nowrap">0.56 MB</td>
      <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap">0.71 MB</td>
    <td>1.27x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap">1.96 MB</td>
    <td>3.53x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap">1.93 MB</td>
    <td>3.48x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap">1.76 MB</td>
    <td>3.16x</td>
  </tr>
</table>
<hr/>
