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
    <td style="white-space: nowrap; text-align: right">709.02 μs</td>
    <td style="white-space: nowrap; text-align: right">±14.82%</td>
    <td style="white-space: nowrap; text-align: right">680.90 μs</td>
    <td style="white-space: nowrap; text-align: right">919.90 μs</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap; text-align: right">1.15 K</td>
    <td style="white-space: nowrap; text-align: right">870.74 μs</td>
    <td style="white-space: nowrap; text-align: right">±12.29%</td>
    <td style="white-space: nowrap; text-align: right">844.90 μs</td>
    <td style="white-space: nowrap; text-align: right">1107.24 μs</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">0.0670 K</td>
    <td style="white-space: nowrap; text-align: right">14925.22 μs</td>
    <td style="white-space: nowrap; text-align: right">±6.04%</td>
    <td style="white-space: nowrap; text-align: right">14699.40 μs</td>
    <td style="white-space: nowrap; text-align: right">19510.88 μs</td>
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
    <td style="white-space: nowrap; text-align: right">1.15 K</td>
    <td style="white-space: nowrap; text-align: right">1.23x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">0.0670 K</td>
    <td style="white-space: nowrap; text-align: right">21.05x</td>
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
    <td style="white-space: nowrap; text-align: right">1.39 K</td>
    <td style="white-space: nowrap; text-align: right">721.96 μs</td>
    <td style="white-space: nowrap; text-align: right">±13.92%</td>
    <td style="white-space: nowrap; text-align: right">702.90 μs</td>
    <td style="white-space: nowrap; text-align: right">920.66 μs</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap; text-align: right">1.10 K</td>
    <td style="white-space: nowrap; text-align: right">907.83 μs</td>
    <td style="white-space: nowrap; text-align: right">±14.44%</td>
    <td style="white-space: nowrap; text-align: right">877.90 μs</td>
    <td style="white-space: nowrap; text-align: right">1295.97 μs</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">0.0104 K</td>
    <td style="white-space: nowrap; text-align: right">95855.60 μs</td>
    <td style="white-space: nowrap; text-align: right">±3.94%</td>
    <td style="white-space: nowrap; text-align: right">94667.90 μs</td>
    <td style="white-space: nowrap; text-align: right">121954.52 μs</td>
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
    <td style="white-space: nowrap;text-align: right">1.39 K</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap; text-align: right">1.10 K</td>
    <td style="white-space: nowrap; text-align: right">1.26x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">0.0104 K</td>
    <td style="white-space: nowrap; text-align: right">132.77x</td>
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
    <td style="white-space: nowrap; text-align: right">1.43 K</td>
    <td style="white-space: nowrap; text-align: right">698.12 μs</td>
    <td style="white-space: nowrap; text-align: right">±12.42%</td>
    <td style="white-space: nowrap; text-align: right">670.90 μs</td>
    <td style="white-space: nowrap; text-align: right">922.96 μs</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap; text-align: right">1.12 K</td>
    <td style="white-space: nowrap; text-align: right">891.32 μs</td>
    <td style="white-space: nowrap; text-align: right">±12.93%</td>
    <td style="white-space: nowrap; text-align: right">868.90 μs</td>
    <td style="white-space: nowrap; text-align: right">1298.96 μs</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">0.0822 K</td>
    <td style="white-space: nowrap; text-align: right">12170.22 μs</td>
    <td style="white-space: nowrap; text-align: right">±9.97%</td>
    <td style="white-space: nowrap; text-align: right">11859.90 μs</td>
    <td style="white-space: nowrap; text-align: right">18338.27 μs</td>
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
    <td style="white-space: nowrap;text-align: right">1.43 K</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap; text-align: right">1.12 K</td>
    <td style="white-space: nowrap; text-align: right">1.28x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">0.0822 K</td>
    <td style="white-space: nowrap; text-align: right">17.43x</td>
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
    <td style="white-space: nowrap; text-align: right">169.64</td>
    <td style="white-space: nowrap; text-align: right">5.89 ms</td>
    <td style="white-space: nowrap; text-align: right">±9.17%</td>
    <td style="white-space: nowrap; text-align: right">5.78 ms</td>
    <td style="white-space: nowrap; text-align: right">8.33 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap; text-align: right">75.94</td>
    <td style="white-space: nowrap; text-align: right">13.17 ms</td>
    <td style="white-space: nowrap; text-align: right">±5.96%</td>
    <td style="white-space: nowrap; text-align: right">12.99 ms</td>
    <td style="white-space: nowrap; text-align: right">18.09 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">71.11</td>
    <td style="white-space: nowrap; text-align: right">14.06 ms</td>
    <td style="white-space: nowrap; text-align: right">±15.37%</td>
    <td style="white-space: nowrap; text-align: right">13.51 ms</td>
    <td style="white-space: nowrap; text-align: right">24.54 ms</td>
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
    <td style="white-space: nowrap;text-align: right">169.64</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap; text-align: right">75.94</td>
    <td style="white-space: nowrap; text-align: right">2.23x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">71.11</td>
    <td style="white-space: nowrap; text-align: right">2.39x</td>
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
    <td style="white-space: nowrap; text-align: right">107.04</td>
    <td style="white-space: nowrap; text-align: right">9.34 ms</td>
    <td style="white-space: nowrap; text-align: right">±9.35%</td>
    <td style="white-space: nowrap; text-align: right">9.11 ms</td>
    <td style="white-space: nowrap; text-align: right">14.64 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap; text-align: right">55.85</td>
    <td style="white-space: nowrap; text-align: right">17.90 ms</td>
    <td style="white-space: nowrap; text-align: right">±7.85%</td>
    <td style="white-space: nowrap; text-align: right">17.47 ms</td>
    <td style="white-space: nowrap; text-align: right">24.89 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">10.30</td>
    <td style="white-space: nowrap; text-align: right">97.11 ms</td>
    <td style="white-space: nowrap; text-align: right">±6.66%</td>
    <td style="white-space: nowrap; text-align: right">95.18 ms</td>
    <td style="white-space: nowrap; text-align: right">135.82 ms</td>
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
    <td style="white-space: nowrap;text-align: right">107.04</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap; text-align: right">55.85</td>
    <td style="white-space: nowrap; text-align: right">1.92x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">10.30</td>
    <td style="white-space: nowrap; text-align: right">10.39x</td>
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
    <td style="white-space: nowrap; text-align: right">1.71 K</td>
    <td style="white-space: nowrap; text-align: right">585.12 μs</td>
    <td style="white-space: nowrap; text-align: right">±15.82%</td>
    <td style="white-space: nowrap; text-align: right">562.90 μs</td>
    <td style="white-space: nowrap; text-align: right">753.44 μs</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap; text-align: right">1.25 K</td>
    <td style="white-space: nowrap; text-align: right">801.90 μs</td>
    <td style="white-space: nowrap; text-align: right">±14.40%</td>
    <td style="white-space: nowrap; text-align: right">773.90 μs</td>
    <td style="white-space: nowrap; text-align: right">1111.50 μs</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">0.171 K</td>
    <td style="white-space: nowrap; text-align: right">5856.78 μs</td>
    <td style="white-space: nowrap; text-align: right">±11.81%</td>
    <td style="white-space: nowrap; text-align: right">5679.40 μs</td>
    <td style="white-space: nowrap; text-align: right">9134.27 μs</td>
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
    <td style="white-space: nowrap;text-align: right">1.71 K</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap; text-align: right">1.25 K</td>
    <td style="white-space: nowrap; text-align: right">1.37x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">0.171 K</td>
    <td style="white-space: nowrap; text-align: right">10.01x</td>
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
    <td style="white-space: nowrap">173.32 KB</td>
      <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap">105.73 KB</td>
    <td>0.61x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap">1608.35 KB</td>
    <td>9.28x</td>
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
    <td style="white-space: nowrap; text-align: right">500.79</td>
    <td style="white-space: nowrap; text-align: right">2.00 ms</td>
    <td style="white-space: nowrap; text-align: right">±15.46%</td>
    <td style="white-space: nowrap; text-align: right">1.92 ms</td>
    <td style="white-space: nowrap; text-align: right">3.18 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap; text-align: right">275.85</td>
    <td style="white-space: nowrap; text-align: right">3.63 ms</td>
    <td style="white-space: nowrap; text-align: right">±11.02%</td>
    <td style="white-space: nowrap; text-align: right">3.54 ms</td>
    <td style="white-space: nowrap; text-align: right">5.35 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">141.90</td>
    <td style="white-space: nowrap; text-align: right">7.05 ms</td>
    <td style="white-space: nowrap; text-align: right">±24.82%</td>
    <td style="white-space: nowrap; text-align: right">6.75 ms</td>
    <td style="white-space: nowrap; text-align: right">11.51 ms</td>
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
    <td style="white-space: nowrap;text-align: right">500.79</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap; text-align: right">275.85</td>
    <td style="white-space: nowrap; text-align: right">1.82x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">141.90</td>
    <td style="white-space: nowrap; text-align: right">3.53x</td>
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
