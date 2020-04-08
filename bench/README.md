# Benchmark: TimeZoneDatabase

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
- **ok_gap_ambiguous:** **ok**, **gap**, and **ambiguous** together.
- **last_year:** 1000 `(datetime, time_zone)` arguments with random time zone
  and a date time from now to one year in the past. The data is calculated
  once for all test candidates.
- **berlin_gap_2020**: Gaps in the time zone `Europe/Berlin` in 2020.
- **berlin_ambiguous_2020**: Ambiguous date time in the time zone
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
    <td style="white-space: nowrap; text-align: right">194.88</td>
    <td style="white-space: nowrap; text-align: right">5.13 ms</td>
    <td style="white-space: nowrap; text-align: right">±5.45%</td>
    <td style="white-space: nowrap; text-align: right">5.08 ms</td>
    <td style="white-space: nowrap; text-align: right">6.16 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap; text-align: right">119.95</td>
    <td style="white-space: nowrap; text-align: right">8.34 ms</td>
    <td style="white-space: nowrap; text-align: right">±11.28%</td>
    <td style="white-space: nowrap; text-align: right">8.13 ms</td>
    <td style="white-space: nowrap; text-align: right">12.30 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap; text-align: right">116.08</td>
    <td style="white-space: nowrap; text-align: right">8.61 ms</td>
    <td style="white-space: nowrap; text-align: right">±9.55%</td>
    <td style="white-space: nowrap; text-align: right">8.47 ms</td>
    <td style="white-space: nowrap; text-align: right">12.03 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">105.46</td>
    <td style="white-space: nowrap; text-align: right">9.48 ms</td>
    <td style="white-space: nowrap; text-align: right">±5.68%</td>
    <td style="white-space: nowrap; text-align: right">9.36 ms</td>
    <td style="white-space: nowrap; text-align: right">11.20 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap; text-align: right">97.18</td>
    <td style="white-space: nowrap; text-align: right">10.29 ms</td>
    <td style="white-space: nowrap; text-align: right">±8.93%</td>
    <td style="white-space: nowrap; text-align: right">10.00 ms</td>
    <td style="white-space: nowrap; text-align: right">13.29 ms</td>
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
    <td style="white-space: nowrap;text-align: right">194.88</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap; text-align: right">119.95</td>
    <td style="white-space: nowrap; text-align: right">1.62x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap; text-align: right">116.08</td>
    <td style="white-space: nowrap; text-align: right">1.68x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">105.46</td>
    <td style="white-space: nowrap; text-align: right">1.85x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap; text-align: right">97.18</td>
    <td style="white-space: nowrap; text-align: right">2.01x</td>
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
    <td style="white-space: nowrap">1.69 MB</td>
      <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap">4.07 MB</td>
    <td>2.42x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap">2.61 MB</td>
    <td>1.55x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap">1.73 MB</td>
    <td>1.03x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap">4.05 MB</td>
    <td>2.4x</td>
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
    <td style="white-space: nowrap; text-align: right">651.69</td>
    <td style="white-space: nowrap; text-align: right">1.53 ms</td>
    <td style="white-space: nowrap; text-align: right">±9.14%</td>
    <td style="white-space: nowrap; text-align: right">1.50 ms</td>
    <td style="white-space: nowrap; text-align: right">2.09 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_pst</td>
    <td style="white-space: nowrap; text-align: right">640.38</td>
    <td style="white-space: nowrap; text-align: right">1.56 ms</td>
    <td style="white-space: nowrap; text-align: right">±7.71%</td>
    <td style="white-space: nowrap; text-align: right">1.53 ms</td>
    <td style="white-space: nowrap; text-align: right">2.05 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap; text-align: right">118.61</td>
    <td style="white-space: nowrap; text-align: right">8.43 ms</td>
    <td style="white-space: nowrap; text-align: right">±4.55%</td>
    <td style="white-space: nowrap; text-align: right">8.35 ms</td>
    <td style="white-space: nowrap; text-align: right">9.90 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap; text-align: right">91.07</td>
    <td style="white-space: nowrap; text-align: right">10.98 ms</td>
    <td style="white-space: nowrap; text-align: right">±5.10%</td>
    <td style="white-space: nowrap; text-align: right">10.87 ms</td>
    <td style="white-space: nowrap; text-align: right">12.95 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">29.27</td>
    <td style="white-space: nowrap; text-align: right">34.16 ms</td>
    <td style="white-space: nowrap; text-align: right">±3.29%</td>
    <td style="white-space: nowrap; text-align: right">33.86 ms</td>
    <td style="white-space: nowrap; text-align: right">38.62 ms</td>
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
    <td style="white-space: nowrap;text-align: right">651.69</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_pst</td>
    <td style="white-space: nowrap; text-align: right">640.38</td>
    <td style="white-space: nowrap; text-align: right">1.02x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap; text-align: right">118.61</td>
    <td style="white-space: nowrap; text-align: right">5.49x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap; text-align: right">91.07</td>
    <td style="white-space: nowrap; text-align: right">7.16x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">29.27</td>
    <td style="white-space: nowrap; text-align: right">22.26x</td>
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
    <td style="white-space: nowrap">0.32 MB</td>
      <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_pst</td>
    <td style="white-space: nowrap">0.93 MB</td>
    <td>2.9x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap">11.14 MB</td>
    <td>34.75x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap">10.26 MB</td>
    <td>32.01x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap">3.97 MB</td>
    <td>12.38x</td>
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
    <td style="white-space: nowrap; text-align: right">649.29</td>
    <td style="white-space: nowrap; text-align: right">1.54 ms</td>
    <td style="white-space: nowrap; text-align: right">±10.00%</td>
    <td style="white-space: nowrap; text-align: right">1.50 ms</td>
    <td style="white-space: nowrap; text-align: right">2.16 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_pst</td>
    <td style="white-space: nowrap; text-align: right">266.00</td>
    <td style="white-space: nowrap; text-align: right">3.76 ms</td>
    <td style="white-space: nowrap; text-align: right">±5.90%</td>
    <td style="white-space: nowrap; text-align: right">3.72 ms</td>
    <td style="white-space: nowrap; text-align: right">4.67 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap; text-align: right">91.92</td>
    <td style="white-space: nowrap; text-align: right">10.88 ms</td>
    <td style="white-space: nowrap; text-align: right">±5.55%</td>
    <td style="white-space: nowrap; text-align: right">10.74 ms</td>
    <td style="white-space: nowrap; text-align: right">13.44 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap; text-align: right">75.06</td>
    <td style="white-space: nowrap; text-align: right">13.32 ms</td>
    <td style="white-space: nowrap; text-align: right">±4.86%</td>
    <td style="white-space: nowrap; text-align: right">13.17 ms</td>
    <td style="white-space: nowrap; text-align: right">15.97 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">5.73</td>
    <td style="white-space: nowrap; text-align: right">174.57 ms</td>
    <td style="white-space: nowrap; text-align: right">±1.52%</td>
    <td style="white-space: nowrap; text-align: right">174.25 ms</td>
    <td style="white-space: nowrap; text-align: right">182.41 ms</td>
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
    <td style="white-space: nowrap;text-align: right">649.29</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_pst</td>
    <td style="white-space: nowrap; text-align: right">266.00</td>
    <td style="white-space: nowrap; text-align: right">2.44x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap; text-align: right">91.92</td>
    <td style="white-space: nowrap; text-align: right">7.06x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap; text-align: right">75.06</td>
    <td style="white-space: nowrap; text-align: right">8.65x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">5.73</td>
    <td style="white-space: nowrap; text-align: right">113.34x</td>
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
    <td style="white-space: nowrap">0.35 MB</td>
      <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_pst</td>
    <td style="white-space: nowrap">1.95 MB</td>
    <td>5.54x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap">11.17 MB</td>
    <td>31.83x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap">11.54 MB</td>
    <td>32.88x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap">135.87 MB</td>
    <td>387.16x</td>
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
    <td style="white-space: nowrap; text-align: right">125.96</td>
    <td style="white-space: nowrap; text-align: right">7.94 ms</td>
    <td style="white-space: nowrap; text-align: right">±6.39%</td>
    <td style="white-space: nowrap; text-align: right">7.82 ms</td>
    <td style="white-space: nowrap; text-align: right">10.09 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap; text-align: right">91.31</td>
    <td style="white-space: nowrap; text-align: right">10.95 ms</td>
    <td style="white-space: nowrap; text-align: right">±6.91%</td>
    <td style="white-space: nowrap; text-align: right">10.75 ms</td>
    <td style="white-space: nowrap; text-align: right">14.30 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap; text-align: right">90.23</td>
    <td style="white-space: nowrap; text-align: right">11.08 ms</td>
    <td style="white-space: nowrap; text-align: right">±7.35%</td>
    <td style="white-space: nowrap; text-align: right">10.97 ms</td>
    <td style="white-space: nowrap; text-align: right">13.75 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap; text-align: right">73.98</td>
    <td style="white-space: nowrap; text-align: right">13.52 ms</td>
    <td style="white-space: nowrap; text-align: right">±7.97%</td>
    <td style="white-space: nowrap; text-align: right">13.14 ms</td>
    <td style="white-space: nowrap; text-align: right">16.87 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">18.04</td>
    <td style="white-space: nowrap; text-align: right">55.44 ms</td>
    <td style="white-space: nowrap; text-align: right">±3.27%</td>
    <td style="white-space: nowrap; text-align: right">55.02 ms</td>
    <td style="white-space: nowrap; text-align: right">64.40 ms</td>
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
    <td style="white-space: nowrap;text-align: right">125.96</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap; text-align: right">91.31</td>
    <td style="white-space: nowrap; text-align: right">1.38x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap; text-align: right">90.23</td>
    <td style="white-space: nowrap; text-align: right">1.4x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap; text-align: right">73.98</td>
    <td style="white-space: nowrap; text-align: right">1.7x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">18.04</td>
    <td style="white-space: nowrap; text-align: right">6.98x</td>
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
    <td style="white-space: nowrap">2.36 MB</td>
      <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap">4.57 MB</td>
    <td>1.93x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap">3.46 MB</td>
    <td>1.46x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap">4.56 MB</td>
    <td>1.93x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap">41.31 MB</td>
    <td>17.5x</td>
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
    <td style="white-space: nowrap">time_zone_info_pst</td>
    <td style="white-space: nowrap; text-align: right">669.94</td>
    <td style="white-space: nowrap; text-align: right">1.49 ms</td>
    <td style="white-space: nowrap; text-align: right">±8.32%</td>
    <td style="white-space: nowrap; text-align: right">1.46 ms</td>
    <td style="white-space: nowrap; text-align: right">1.99 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap; text-align: right">616.43</td>
    <td style="white-space: nowrap; text-align: right">1.62 ms</td>
    <td style="white-space: nowrap; text-align: right">±17.39%</td>
    <td style="white-space: nowrap; text-align: right">1.54 ms</td>
    <td style="white-space: nowrap; text-align: right">2.85 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap; text-align: right">179.59</td>
    <td style="white-space: nowrap; text-align: right">5.57 ms</td>
    <td style="white-space: nowrap; text-align: right">±9.00%</td>
    <td style="white-space: nowrap; text-align: right">5.44 ms</td>
    <td style="white-space: nowrap; text-align: right">7.59 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap; text-align: right">123.62</td>
    <td style="white-space: nowrap; text-align: right">8.09 ms</td>
    <td style="white-space: nowrap; text-align: right">±11.10%</td>
    <td style="white-space: nowrap; text-align: right">7.82 ms</td>
    <td style="white-space: nowrap; text-align: right">11.02 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">70.36</td>
    <td style="white-space: nowrap; text-align: right">14.21 ms</td>
    <td style="white-space: nowrap; text-align: right">±5.54%</td>
    <td style="white-space: nowrap; text-align: right">14.06 ms</td>
    <td style="white-space: nowrap; text-align: right">16.57 ms</td>
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
    <td style="white-space: nowrap;text-align: right">669.94</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap; text-align: right">616.43</td>
    <td style="white-space: nowrap; text-align: right">1.09x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap; text-align: right">179.59</td>
    <td style="white-space: nowrap; text-align: right">3.73x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap; text-align: right">123.62</td>
    <td style="white-space: nowrap; text-align: right">5.42x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">70.36</td>
    <td style="white-space: nowrap; text-align: right">9.52x</td>
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
    <td style="white-space: nowrap">0.79 MB</td>
      <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap">0.31 MB</td>
    <td>0.39x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap">4.94 MB</td>
    <td>6.23x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap">5.13 MB</td>
    <td>6.47x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap">4.83 MB</td>
    <td>6.09x</td>
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
    <td style="white-space: nowrap; text-align: right">537.43</td>
    <td style="white-space: nowrap; text-align: right">1.86 ms</td>
    <td style="white-space: nowrap; text-align: right">±12.20%</td>
    <td style="white-space: nowrap; text-align: right">1.80 ms</td>
    <td style="white-space: nowrap; text-align: right">2.76 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap; text-align: right">450.23</td>
    <td style="white-space: nowrap; text-align: right">2.22 ms</td>
    <td style="white-space: nowrap; text-align: right">±8.13%</td>
    <td style="white-space: nowrap; text-align: right">2.18 ms</td>
    <td style="white-space: nowrap; text-align: right">3.00 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap; text-align: right">301.99</td>
    <td style="white-space: nowrap; text-align: right">3.31 ms</td>
    <td style="white-space: nowrap; text-align: right">±8.35%</td>
    <td style="white-space: nowrap; text-align: right">3.25 ms</td>
    <td style="white-space: nowrap; text-align: right">4.46 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap; text-align: right">222.81</td>
    <td style="white-space: nowrap; text-align: right">4.49 ms</td>
    <td style="white-space: nowrap; text-align: right">±13.16%</td>
    <td style="white-space: nowrap; text-align: right">4.31 ms</td>
    <td style="white-space: nowrap; text-align: right">6.68 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">203.28</td>
    <td style="white-space: nowrap; text-align: right">4.92 ms</td>
    <td style="white-space: nowrap; text-align: right">±6.74%</td>
    <td style="white-space: nowrap; text-align: right">4.85 ms</td>
    <td style="white-space: nowrap; text-align: right">6.19 ms</td>
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
    <td style="white-space: nowrap;text-align: right">537.43</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap; text-align: right">450.23</td>
    <td style="white-space: nowrap; text-align: right">1.19x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap; text-align: right">301.99</td>
    <td style="white-space: nowrap; text-align: right">1.78x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap; text-align: right">222.81</td>
    <td style="white-space: nowrap; text-align: right">2.41x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">203.28</td>
    <td style="white-space: nowrap; text-align: right">2.64x</td>
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
    <td style="white-space: nowrap">0.73 MB</td>
      <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap">0.66 MB</td>
    <td>0.9x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap">1.92 MB</td>
    <td>2.62x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap">1.97 MB</td>
    <td>2.7x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap">1.29 MB</td>
    <td>1.76x</td>
  </tr>
</table>
<hr/>

__Input: ok_gap_ambiguous__

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
    <td style="white-space: nowrap; text-align: right">63.90</td>
    <td style="white-space: nowrap; text-align: right">15.65 ms</td>
    <td style="white-space: nowrap; text-align: right">±8.57%</td>
    <td style="white-space: nowrap; text-align: right">15.43 ms</td>
    <td style="white-space: nowrap; text-align: right">21.34 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap; text-align: right">46.46</td>
    <td style="white-space: nowrap; text-align: right">21.52 ms</td>
    <td style="white-space: nowrap; text-align: right">±4.74%</td>
    <td style="white-space: nowrap; text-align: right">21.31 ms</td>
    <td style="white-space: nowrap; text-align: right">26.05 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap; text-align: right">43.76</td>
    <td style="white-space: nowrap; text-align: right">22.85 ms</td>
    <td style="white-space: nowrap; text-align: right">±4.67%</td>
    <td style="white-space: nowrap; text-align: right">22.56 ms</td>
    <td style="white-space: nowrap; text-align: right">26.26 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap; text-align: right">33.61</td>
    <td style="white-space: nowrap; text-align: right">29.75 ms</td>
    <td style="white-space: nowrap; text-align: right">±11.55%</td>
    <td style="white-space: nowrap; text-align: right">28.40 ms</td>
    <td style="white-space: nowrap; text-align: right">39.62 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">14.60</td>
    <td style="white-space: nowrap; text-align: right">68.49 ms</td>
    <td style="white-space: nowrap; text-align: right">±3.00%</td>
    <td style="white-space: nowrap; text-align: right">67.87 ms</td>
    <td style="white-space: nowrap; text-align: right">77.79 ms</td>
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
    <td style="white-space: nowrap;text-align: right">63.90</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap; text-align: right">46.46</td>
    <td style="white-space: nowrap; text-align: right">1.38x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap; text-align: right">43.76</td>
    <td style="white-space: nowrap; text-align: right">1.46x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap; text-align: right">33.61</td>
    <td style="white-space: nowrap; text-align: right">1.9x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">14.60</td>
    <td style="white-space: nowrap; text-align: right">4.38x</td>
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
    <td style="white-space: nowrap">4.78 MB</td>
      <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap">6.74 MB</td>
    <td>1.41x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap">10.62 MB</td>
    <td>2.22x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap">10.63 MB</td>
    <td>2.22x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap">44.74 MB</td>
    <td>9.36x</td>
  </tr>
</table>
<hr/>
