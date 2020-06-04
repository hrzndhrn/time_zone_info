# Benchmark

This benchmark compares `TimeZoneInfo` with
[`Tzdata`](https://github.com/lau/tzdata) and
[`Tz`](https://github.com/mathieuprog/tz).

All testees have an implementation for `TimeZoneDatabas`. For the benchmark,
each of them calls the function
`TimeZoneDatabase.time_zone_periods_from_wall_datetime/2`.

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

The inputs **world_ok**, **world_gap**, and **world_ambiguous** containing
random time zones and date times between 1900 and 2050.

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
    <td style="white-space: nowrap">time_zone_info</td>
    <td style="white-space: nowrap; text-align: right">1.41 K</td>
    <td style="white-space: nowrap; text-align: right">710.93 μs</td>
    <td style="white-space: nowrap; text-align: right">±9.14%</td>
    <td style="white-space: nowrap; text-align: right">688.96 μs</td>
    <td style="white-space: nowrap; text-align: right">938.96 μs</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap; text-align: right">1.16 K</td>
    <td style="white-space: nowrap; text-align: right">862.53 μs</td>
    <td style="white-space: nowrap; text-align: right">±8.02%</td>
    <td style="white-space: nowrap; text-align: right">838.96 μs</td>
    <td style="white-space: nowrap; text-align: right">1071.96 μs</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">0.0647 K</td>
    <td style="white-space: nowrap; text-align: right">15455.62 μs</td>
    <td style="white-space: nowrap; text-align: right">±6.35%</td>
    <td style="white-space: nowrap; text-align: right">15294.96 μs</td>
    <td style="white-space: nowrap; text-align: right">20135.28 μs</td>
  </tr>
</table>
Comparison
<table style="width: 1%">
  <tr>
    <th>Name</th>
    <th style="text-align: right">IPS</th>
    <th style="text-align: right">Slower</th>
  <tr>
    <td style="white-space: nowrap">time_zone_info</td>
    <td style="white-space: nowrap;text-align: right">1.41 K</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap; text-align: right">1.16 K</td>
    <td style="white-space: nowrap; text-align: right">1.21x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">0.0647 K</td>
    <td style="white-space: nowrap; text-align: right">21.74x</td>
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
    <td style="white-space: nowrap">time_zone_info</td>
    <td style="white-space: nowrap">185.27 KB</td>
      <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap">109.59 KB</td>
    <td>0.59x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap">1800.47 KB</td>
    <td>9.72x</td>
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
    <td style="white-space: nowrap">time_zone_info</td>
    <td style="white-space: nowrap; text-align: right">1.35 K</td>
    <td style="white-space: nowrap; text-align: right">741.14 μs</td>
    <td style="white-space: nowrap; text-align: right">±12.24%</td>
    <td style="white-space: nowrap; text-align: right">716.96 μs</td>
    <td style="white-space: nowrap; text-align: right">1060.36 μs</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap; text-align: right">1.14 K</td>
    <td style="white-space: nowrap; text-align: right">875.09 μs</td>
    <td style="white-space: nowrap; text-align: right">±15.48%</td>
    <td style="white-space: nowrap; text-align: right">848.96 μs</td>
    <td style="white-space: nowrap; text-align: right">1096.96 μs</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">0.0102 K</td>
    <td style="white-space: nowrap; text-align: right">97632.82 μs</td>
    <td style="white-space: nowrap; text-align: right">±8.90%</td>
    <td style="white-space: nowrap; text-align: right">95090.96 μs</td>
    <td style="white-space: nowrap; text-align: right">152380.76 μs</td>
  </tr>
</table>
Comparison
<table style="width: 1%">
  <tr>
    <th>Name</th>
    <th style="text-align: right">IPS</th>
    <th style="text-align: right">Slower</th>
  <tr>
    <td style="white-space: nowrap">time_zone_info</td>
    <td style="white-space: nowrap;text-align: right">1.35 K</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap; text-align: right">1.14 K</td>
    <td style="white-space: nowrap; text-align: right">1.18x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">0.0102 K</td>
    <td style="white-space: nowrap; text-align: right">131.73x</td>
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
    <td style="white-space: nowrap">time_zone_info</td>
    <td style="white-space: nowrap">200.92 KB</td>
      <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap">120.03 KB</td>
    <td>0.6x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap">44294.75 KB</td>
    <td>220.46x</td>
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
    <td style="white-space: nowrap">time_zone_info</td>
    <td style="white-space: nowrap; text-align: right">1.40 K</td>
    <td style="white-space: nowrap; text-align: right">715.11 μs</td>
    <td style="white-space: nowrap; text-align: right">±11.07%</td>
    <td style="white-space: nowrap; text-align: right">696.96 μs</td>
    <td style="white-space: nowrap; text-align: right">1006.45 μs</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap; text-align: right">1.16 K</td>
    <td style="white-space: nowrap; text-align: right">860.17 μs</td>
    <td style="white-space: nowrap; text-align: right">±13.77%</td>
    <td style="white-space: nowrap; text-align: right">830.96 μs</td>
    <td style="white-space: nowrap; text-align: right">1241.90 μs</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">0.0811 K</td>
    <td style="white-space: nowrap; text-align: right">12335.43 μs</td>
    <td style="white-space: nowrap; text-align: right">±13.67%</td>
    <td style="white-space: nowrap; text-align: right">12093.96 μs</td>
    <td style="white-space: nowrap; text-align: right">21716.52 μs</td>
  </tr>
</table>
Comparison
<table style="width: 1%">
  <tr>
    <th>Name</th>
    <th style="text-align: right">IPS</th>
    <th style="text-align: right">Slower</th>
  <tr>
    <td style="white-space: nowrap">time_zone_info</td>
    <td style="white-space: nowrap;text-align: right">1.40 K</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap; text-align: right">1.16 K</td>
    <td style="white-space: nowrap; text-align: right">1.2x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">0.0811 K</td>
    <td style="white-space: nowrap; text-align: right">17.25x</td>
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
    <td style="white-space: nowrap">time_zone_info</td>
    <td style="white-space: nowrap">164.39 KB</td>
      <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap">101.74 KB</td>
    <td>0.62x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap">970.55 KB</td>
    <td>5.9x</td>
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
    <td style="white-space: nowrap">time_zone_info</td>
    <td style="white-space: nowrap; text-align: right">166.86</td>
    <td style="white-space: nowrap; text-align: right">5.99 ms</td>
    <td style="white-space: nowrap; text-align: right">±9.33%</td>
    <td style="white-space: nowrap; text-align: right">5.88 ms</td>
    <td style="white-space: nowrap; text-align: right">7.89 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap; text-align: right">71.71</td>
    <td style="white-space: nowrap; text-align: right">13.95 ms</td>
    <td style="white-space: nowrap; text-align: right">±13.71%</td>
    <td style="white-space: nowrap; text-align: right">13.51 ms</td>
    <td style="white-space: nowrap; text-align: right">24.10 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">71.18</td>
    <td style="white-space: nowrap; text-align: right">14.05 ms</td>
    <td style="white-space: nowrap; text-align: right">±5.50%</td>
    <td style="white-space: nowrap; text-align: right">13.89 ms</td>
    <td style="white-space: nowrap; text-align: right">17.27 ms</td>
  </tr>
</table>
Comparison
<table style="width: 1%">
  <tr>
    <th>Name</th>
    <th style="text-align: right">IPS</th>
    <th style="text-align: right">Slower</th>
  <tr>
    <td style="white-space: nowrap">time_zone_info</td>
    <td style="white-space: nowrap;text-align: right">166.86</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap; text-align: right">71.71</td>
    <td style="white-space: nowrap; text-align: right">2.33x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">71.18</td>
    <td style="white-space: nowrap; text-align: right">2.34x</td>
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
    <td style="white-space: nowrap">time_zone_info</td>
    <td style="white-space: nowrap">1.07 MB</td>
      <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap">2.85 MB</td>
    <td>2.66x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap">2.35 MB</td>
    <td>2.19x</td>
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
    <td style="white-space: nowrap">time_zone_info</td>
    <td style="white-space: nowrap; text-align: right">102.20</td>
    <td style="white-space: nowrap; text-align: right">9.78 ms</td>
    <td style="white-space: nowrap; text-align: right">±11.52%</td>
    <td style="white-space: nowrap; text-align: right">9.58 ms</td>
    <td style="white-space: nowrap; text-align: right">14.09 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap; text-align: right">56.26</td>
    <td style="white-space: nowrap; text-align: right">17.78 ms</td>
    <td style="white-space: nowrap; text-align: right">±4.33%</td>
    <td style="white-space: nowrap; text-align: right">17.50 ms</td>
    <td style="white-space: nowrap; text-align: right">20.95 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">9.92</td>
    <td style="white-space: nowrap; text-align: right">100.84 ms</td>
    <td style="white-space: nowrap; text-align: right">±12.76%</td>
    <td style="white-space: nowrap; text-align: right">99.59 ms</td>
    <td style="white-space: nowrap; text-align: right">216.71 ms</td>
  </tr>
</table>
Comparison
<table style="width: 1%">
  <tr>
    <th>Name</th>
    <th style="text-align: right">IPS</th>
    <th style="text-align: right">Slower</th>
  <tr>
    <td style="white-space: nowrap">time_zone_info</td>
    <td style="white-space: nowrap;text-align: right">102.20</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap; text-align: right">56.26</td>
    <td style="white-space: nowrap; text-align: right">1.82x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">9.92</td>
    <td style="white-space: nowrap; text-align: right">10.31x</td>
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
    <td style="white-space: nowrap">time_zone_info</td>
    <td style="white-space: nowrap">1.73 MB</td>
      <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap">3.73 MB</td>
    <td>2.16x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap">42.96 MB</td>
    <td>24.89x</td>
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
    <td style="white-space: nowrap">time_zone_info</td>
    <td style="white-space: nowrap; text-align: right">1.62 K</td>
    <td style="white-space: nowrap; text-align: right">616.90 μs</td>
    <td style="white-space: nowrap; text-align: right">±14.35%</td>
    <td style="white-space: nowrap; text-align: right">590.96 μs</td>
    <td style="white-space: nowrap; text-align: right">972.00 μs</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap; text-align: right">1.21 K</td>
    <td style="white-space: nowrap; text-align: right">823.06 μs</td>
    <td style="white-space: nowrap; text-align: right">±12.24%</td>
    <td style="white-space: nowrap; text-align: right">791.96 μs</td>
    <td style="white-space: nowrap; text-align: right">1169.96 μs</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">0.148 K</td>
    <td style="white-space: nowrap; text-align: right">6775.75 μs</td>
    <td style="white-space: nowrap; text-align: right">±9.25%</td>
    <td style="white-space: nowrap; text-align: right">6690.96 μs</td>
    <td style="white-space: nowrap; text-align: right">9047.04 μs</td>
  </tr>
</table>
Comparison
<table style="width: 1%">
  <tr>
    <th>Name</th>
    <th style="text-align: right">IPS</th>
    <th style="text-align: right">Slower</th>
  <tr>
    <td style="white-space: nowrap">time_zone_info</td>
    <td style="white-space: nowrap;text-align: right">1.62 K</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap; text-align: right">1.21 K</td>
    <td style="white-space: nowrap; text-align: right">1.33x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">0.148 K</td>
    <td style="white-space: nowrap; text-align: right">10.98x</td>
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
    <td style="white-space: nowrap">time_zone_info</td>
    <td style="white-space: nowrap">171.55 KB</td>
      <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap">105.45 KB</td>
    <td>0.61x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap">1443.22 KB</td>
    <td>8.41x</td>
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
    <td style="white-space: nowrap">time_zone_info</td>
    <td style="white-space: nowrap; text-align: right">499.82</td>
    <td style="white-space: nowrap; text-align: right">2.00 ms</td>
    <td style="white-space: nowrap; text-align: right">±12.97%</td>
    <td style="white-space: nowrap; text-align: right">1.96 ms</td>
    <td style="white-space: nowrap; text-align: right">2.78 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap; text-align: right">267.96</td>
    <td style="white-space: nowrap; text-align: right">3.73 ms</td>
    <td style="white-space: nowrap; text-align: right">±11.91%</td>
    <td style="white-space: nowrap; text-align: right">3.64 ms</td>
    <td style="white-space: nowrap; text-align: right">5.59 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">143.31</td>
    <td style="white-space: nowrap; text-align: right">6.98 ms</td>
    <td style="white-space: nowrap; text-align: right">±20.64%</td>
    <td style="white-space: nowrap; text-align: right">6.69 ms</td>
    <td style="white-space: nowrap; text-align: right">12.35 ms</td>
  </tr>
</table>
Comparison
<table style="width: 1%">
  <tr>
    <th>Name</th>
    <th style="text-align: right">IPS</th>
    <th style="text-align: right">Slower</th>
  <tr>
    <td style="white-space: nowrap">time_zone_info</td>
    <td style="white-space: nowrap;text-align: right">499.82</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap; text-align: right">267.96</td>
    <td style="white-space: nowrap; text-align: right">1.87x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">143.31</td>
    <td style="white-space: nowrap; text-align: right">3.49x</td>
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
    <td style="white-space: nowrap">time_zone_info</td>
    <td style="white-space: nowrap">379.02 KB</td>
      <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap">724.91 KB</td>
    <td>1.91x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap">1787.70 KB</td>
    <td>4.72x</td>
  </tr>
</table>
<hr/>
