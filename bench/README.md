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
    <td style="white-space: nowrap; text-align: right">399.21</td>
    <td style="white-space: nowrap; text-align: right">2.50 ms</td>
    <td style="white-space: nowrap; text-align: right">±9.16%</td>
    <td style="white-space: nowrap; text-align: right">2.44 ms</td>
    <td style="white-space: nowrap; text-align: right">3.39 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap; text-align: right">182.91</td>
    <td style="white-space: nowrap; text-align: right">5.47 ms</td>
    <td style="white-space: nowrap; text-align: right">±10.38%</td>
    <td style="white-space: nowrap; text-align: right">5.29 ms</td>
    <td style="white-space: nowrap; text-align: right">7.50 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap; text-align: right">121.28</td>
    <td style="white-space: nowrap; text-align: right">8.25 ms</td>
    <td style="white-space: nowrap; text-align: right">±11.59%</td>
    <td style="white-space: nowrap; text-align: right">8.07 ms</td>
    <td style="white-space: nowrap; text-align: right">11.42 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap; text-align: right">114.17</td>
    <td style="white-space: nowrap; text-align: right">8.76 ms</td>
    <td style="white-space: nowrap; text-align: right">±6.86%</td>
    <td style="white-space: nowrap; text-align: right">8.59 ms</td>
    <td style="white-space: nowrap; text-align: right">10.59 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">99.68</td>
    <td style="white-space: nowrap; text-align: right">10.03 ms</td>
    <td style="white-space: nowrap; text-align: right">±7.50%</td>
    <td style="white-space: nowrap; text-align: right">9.84 ms</td>
    <td style="white-space: nowrap; text-align: right">12.68 ms</td>
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
    <td style="white-space: nowrap;text-align: right">399.21</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap; text-align: right">182.91</td>
    <td style="white-space: nowrap; text-align: right">2.18x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap; text-align: right">121.28</td>
    <td style="white-space: nowrap; text-align: right">3.29x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap; text-align: right">114.17</td>
    <td style="white-space: nowrap; text-align: right">3.5x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">99.68</td>
    <td style="white-space: nowrap; text-align: right">4.0x</td>
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
    <td style="white-space: nowrap">3.41 MB</td>
    <td>3.63x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap">3.36 MB</td>
    <td>3.57x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap">2.61 MB</td>
    <td>2.78x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap">1.73 MB</td>
    <td>1.83x</td>
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
    <td style="white-space: nowrap; text-align: right">631.65</td>
    <td style="white-space: nowrap; text-align: right">1.58 ms</td>
    <td style="white-space: nowrap; text-align: right">±10.48%</td>
    <td style="white-space: nowrap; text-align: right">1.54 ms</td>
    <td style="white-space: nowrap; text-align: right">2.32 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_pst</td>
    <td style="white-space: nowrap; text-align: right">595.05</td>
    <td style="white-space: nowrap; text-align: right">1.68 ms</td>
    <td style="white-space: nowrap; text-align: right">±10.62%</td>
    <td style="white-space: nowrap; text-align: right">1.63 ms</td>
    <td style="white-space: nowrap; text-align: right">2.45 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap; text-align: right">107.47</td>
    <td style="white-space: nowrap; text-align: right">9.31 ms</td>
    <td style="white-space: nowrap; text-align: right">±5.64%</td>
    <td style="white-space: nowrap; text-align: right">9.17 ms</td>
    <td style="white-space: nowrap; text-align: right">11.05 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap; text-align: right">84.48</td>
    <td style="white-space: nowrap; text-align: right">11.84 ms</td>
    <td style="white-space: nowrap; text-align: right">±10.05%</td>
    <td style="white-space: nowrap; text-align: right">11.61 ms</td>
    <td style="white-space: nowrap; text-align: right">14.69 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">28.08</td>
    <td style="white-space: nowrap; text-align: right">35.61 ms</td>
    <td style="white-space: nowrap; text-align: right">±2.97%</td>
    <td style="white-space: nowrap; text-align: right">35.35 ms</td>
    <td style="white-space: nowrap; text-align: right">39.94 ms</td>
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
    <td style="white-space: nowrap;text-align: right">631.65</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_pst</td>
    <td style="white-space: nowrap; text-align: right">595.05</td>
    <td style="white-space: nowrap; text-align: right">1.06x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap; text-align: right">107.47</td>
    <td style="white-space: nowrap; text-align: right">5.88x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap; text-align: right">84.48</td>
    <td style="white-space: nowrap; text-align: right">7.48x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">28.08</td>
    <td style="white-space: nowrap; text-align: right">22.49x</td>
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
    <td style="white-space: nowrap; text-align: right">627.39</td>
    <td style="white-space: nowrap; text-align: right">1.59 ms</td>
    <td style="white-space: nowrap; text-align: right">±11.27%</td>
    <td style="white-space: nowrap; text-align: right">1.54 ms</td>
    <td style="white-space: nowrap; text-align: right">2.40 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_pst</td>
    <td style="white-space: nowrap; text-align: right">254.45</td>
    <td style="white-space: nowrap; text-align: right">3.93 ms</td>
    <td style="white-space: nowrap; text-align: right">±8.05%</td>
    <td style="white-space: nowrap; text-align: right">3.84 ms</td>
    <td style="white-space: nowrap; text-align: right">5.08 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap; text-align: right">83.42</td>
    <td style="white-space: nowrap; text-align: right">11.99 ms</td>
    <td style="white-space: nowrap; text-align: right">±12.34%</td>
    <td style="white-space: nowrap; text-align: right">11.63 ms</td>
    <td style="white-space: nowrap; text-align: right">18.60 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap; text-align: right">69.97</td>
    <td style="white-space: nowrap; text-align: right">14.29 ms</td>
    <td style="white-space: nowrap; text-align: right">±4.37%</td>
    <td style="white-space: nowrap; text-align: right">14.18 ms</td>
    <td style="white-space: nowrap; text-align: right">16.55 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">5.54</td>
    <td style="white-space: nowrap; text-align: right">180.34 ms</td>
    <td style="white-space: nowrap; text-align: right">±1.33%</td>
    <td style="white-space: nowrap; text-align: right">179.75 ms</td>
    <td style="white-space: nowrap; text-align: right">186.35 ms</td>
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
    <td style="white-space: nowrap;text-align: right">627.39</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_pst</td>
    <td style="white-space: nowrap; text-align: right">254.45</td>
    <td style="white-space: nowrap; text-align: right">2.47x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap; text-align: right">83.42</td>
    <td style="white-space: nowrap; text-align: right">7.52x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap; text-align: right">69.97</td>
    <td style="white-space: nowrap; text-align: right">8.97x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">5.54</td>
    <td style="white-space: nowrap; text-align: right">113.15x</td>
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
    <td style="white-space: nowrap; text-align: right">237.01</td>
    <td style="white-space: nowrap; text-align: right">4.22 ms</td>
    <td style="white-space: nowrap; text-align: right">±8.96%</td>
    <td style="white-space: nowrap; text-align: right">4.11 ms</td>
    <td style="white-space: nowrap; text-align: right">5.66 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap; text-align: right">126.99</td>
    <td style="white-space: nowrap; text-align: right">7.87 ms</td>
    <td style="white-space: nowrap; text-align: right">±13.08%</td>
    <td style="white-space: nowrap; text-align: right">7.56 ms</td>
    <td style="white-space: nowrap; text-align: right">12.21 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap; text-align: right">94.54</td>
    <td style="white-space: nowrap; text-align: right">10.58 ms</td>
    <td style="white-space: nowrap; text-align: right">±9.71%</td>
    <td style="white-space: nowrap; text-align: right">10.33 ms</td>
    <td style="white-space: nowrap; text-align: right">13.45 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap; text-align: right">87.52</td>
    <td style="white-space: nowrap; text-align: right">11.43 ms</td>
    <td style="white-space: nowrap; text-align: right">±4.75%</td>
    <td style="white-space: nowrap; text-align: right">11.29 ms</td>
    <td style="white-space: nowrap; text-align: right">13.26 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">17.34</td>
    <td style="white-space: nowrap; text-align: right">57.69 ms</td>
    <td style="white-space: nowrap; text-align: right">±3.66%</td>
    <td style="white-space: nowrap; text-align: right">56.90 ms</td>
    <td style="white-space: nowrap; text-align: right">64.50 ms</td>
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
    <td style="white-space: nowrap;text-align: right">237.01</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap; text-align: right">126.99</td>
    <td style="white-space: nowrap; text-align: right">1.87x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap; text-align: right">94.54</td>
    <td style="white-space: nowrap; text-align: right">2.51x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap; text-align: right">87.52</td>
    <td style="white-space: nowrap; text-align: right">2.71x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">17.34</td>
    <td style="white-space: nowrap; text-align: right">13.67x</td>
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
    <td style="white-space: nowrap">1.26 MB</td>
      <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap">3.65 MB</td>
    <td>2.89x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap">3.60 MB</td>
    <td>2.85x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap">3.46 MB</td>
    <td>2.74x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap">41.31 MB</td>
    <td>32.72x</td>
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
    <td style="white-space: nowrap; text-align: right">630.21</td>
    <td style="white-space: nowrap; text-align: right">1.59 ms</td>
    <td style="white-space: nowrap; text-align: right">±13.43%</td>
    <td style="white-space: nowrap; text-align: right">1.52 ms</td>
    <td style="white-space: nowrap; text-align: right">2.56 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap; text-align: right">625.98</td>
    <td style="white-space: nowrap; text-align: right">1.60 ms</td>
    <td style="white-space: nowrap; text-align: right">±19.46%</td>
    <td style="white-space: nowrap; text-align: right">1.50 ms</td>
    <td style="white-space: nowrap; text-align: right">3.02 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap; text-align: right">158.05</td>
    <td style="white-space: nowrap; text-align: right">6.33 ms</td>
    <td style="white-space: nowrap; text-align: right">±11.81%</td>
    <td style="white-space: nowrap; text-align: right">6.11 ms</td>
    <td style="white-space: nowrap; text-align: right">8.64 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap; text-align: right">107.04</td>
    <td style="white-space: nowrap; text-align: right">9.34 ms</td>
    <td style="white-space: nowrap; text-align: right">±13.32%</td>
    <td style="white-space: nowrap; text-align: right">9.03 ms</td>
    <td style="white-space: nowrap; text-align: right">12.69 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">65.23</td>
    <td style="white-space: nowrap; text-align: right">15.33 ms</td>
    <td style="white-space: nowrap; text-align: right">±5.79%</td>
    <td style="white-space: nowrap; text-align: right">15.22 ms</td>
    <td style="white-space: nowrap; text-align: right">17.55 ms</td>
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
    <td style="white-space: nowrap;text-align: right">630.21</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap; text-align: right">625.98</td>
    <td style="white-space: nowrap; text-align: right">1.01x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap; text-align: right">158.05</td>
    <td style="white-space: nowrap; text-align: right">3.99x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap; text-align: right">107.04</td>
    <td style="white-space: nowrap; text-align: right">5.89x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">65.23</td>
    <td style="white-space: nowrap; text-align: right">9.66x</td>
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
    <td style="white-space: nowrap">0.78 MB</td>
      <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap">0.31 MB</td>
    <td>0.4x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap">5.03 MB</td>
    <td>6.48x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap">4.68 MB</td>
    <td>6.03x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap">4.24 MB</td>
    <td>5.47x</td>
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
    <td style="white-space: nowrap; text-align: right">802.32</td>
    <td style="white-space: nowrap; text-align: right">1.25 ms</td>
    <td style="white-space: nowrap; text-align: right">±15.74%</td>
    <td style="white-space: nowrap; text-align: right">1.18 ms</td>
    <td style="white-space: nowrap; text-align: right">2.17 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap; text-align: right">424.18</td>
    <td style="white-space: nowrap; text-align: right">2.36 ms</td>
    <td style="white-space: nowrap; text-align: right">±12.96%</td>
    <td style="white-space: nowrap; text-align: right">2.25 ms</td>
    <td style="white-space: nowrap; text-align: right">3.62 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap; text-align: right">346.70</td>
    <td style="white-space: nowrap; text-align: right">2.88 ms</td>
    <td style="white-space: nowrap; text-align: right">±17.10%</td>
    <td style="white-space: nowrap; text-align: right">2.71 ms</td>
    <td style="white-space: nowrap; text-align: right">4.72 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap; text-align: right">229.44</td>
    <td style="white-space: nowrap; text-align: right">4.36 ms</td>
    <td style="white-space: nowrap; text-align: right">±21.42%</td>
    <td style="white-space: nowrap; text-align: right">4.05 ms</td>
    <td style="white-space: nowrap; text-align: right">7.77 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">193.81</td>
    <td style="white-space: nowrap; text-align: right">5.16 ms</td>
    <td style="white-space: nowrap; text-align: right">±11.40%</td>
    <td style="white-space: nowrap; text-align: right">4.99 ms</td>
    <td style="white-space: nowrap; text-align: right">7.05 ms</td>
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
    <td style="white-space: nowrap;text-align: right">802.32</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap; text-align: right">424.18</td>
    <td style="white-space: nowrap; text-align: right">1.89x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap; text-align: right">346.70</td>
    <td style="white-space: nowrap; text-align: right">2.31x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap; text-align: right">229.44</td>
    <td style="white-space: nowrap; text-align: right">3.5x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">193.81</td>
    <td style="white-space: nowrap; text-align: right">4.14x</td>
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
    <td style="white-space: nowrap">0.66 MB</td>
    <td>1.19x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap">1.75 MB</td>
    <td>3.15x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap">1.65 MB</td>
    <td>2.97x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap">1.29 MB</td>
    <td>2.32x</td>
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
    <td style="white-space: nowrap; text-align: right">121.51</td>
    <td style="white-space: nowrap; text-align: right">8.23 ms</td>
    <td style="white-space: nowrap; text-align: right">±8.21%</td>
    <td style="white-space: nowrap; text-align: right">8.03 ms</td>
    <td style="white-space: nowrap; text-align: right">10.95 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap; text-align: right">62.57</td>
    <td style="white-space: nowrap; text-align: right">15.98 ms</td>
    <td style="white-space: nowrap; text-align: right">±7.27%</td>
    <td style="white-space: nowrap; text-align: right">15.76 ms</td>
    <td style="white-space: nowrap; text-align: right">21.24 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap; text-align: right">44.21</td>
    <td style="white-space: nowrap; text-align: right">22.62 ms</td>
    <td style="white-space: nowrap; text-align: right">±4.17%</td>
    <td style="white-space: nowrap; text-align: right">22.45 ms</td>
    <td style="white-space: nowrap; text-align: right">26.40 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap; text-align: right">42.57</td>
    <td style="white-space: nowrap; text-align: right">23.49 ms</td>
    <td style="white-space: nowrap; text-align: right">±7.37%</td>
    <td style="white-space: nowrap; text-align: right">23.19 ms</td>
    <td style="white-space: nowrap; text-align: right">28.02 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">13.97</td>
    <td style="white-space: nowrap; text-align: right">71.59 ms</td>
    <td style="white-space: nowrap; text-align: right">±2.59%</td>
    <td style="white-space: nowrap; text-align: right">71.35 ms</td>
    <td style="white-space: nowrap; text-align: right">80.32 ms</td>
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
    <td style="white-space: nowrap;text-align: right">121.51</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap; text-align: right">62.57</td>
    <td style="white-space: nowrap; text-align: right">1.94x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap; text-align: right">44.21</td>
    <td style="white-space: nowrap; text-align: right">2.75x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap; text-align: right">42.57</td>
    <td style="white-space: nowrap; text-align: right">2.85x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">13.97</td>
    <td style="white-space: nowrap; text-align: right">8.7x</td>
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
    <td style="white-space: nowrap">2.76 MB</td>
      <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap">8.82 MB</td>
    <td>3.2x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap">6.74 MB</td>
    <td>2.44x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap">8.88 MB</td>
    <td>3.22x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap">44.74 MB</td>
    <td>16.21x</td>
  </tr>
</table>
<hr/>
