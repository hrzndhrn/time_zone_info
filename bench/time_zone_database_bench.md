# Benchmark

This benchmark compares `TimeZoneInfo` with
[`Tzdata`](https://github.com/lau/tzdata) and
[`Tz`](https://github.com/mathieuprog/tz). `TimeZoneInfo` is using
`DataStore.PersistentTerm` in this benchmark.

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
    <td style="white-space: nowrap; text-align: right">1.36 K</td>
    <td style="white-space: nowrap; text-align: right">737.13 μs</td>
    <td style="white-space: nowrap; text-align: right">±12.84%</td>
    <td style="white-space: nowrap; text-align: right">712 μs</td>
    <td style="white-space: nowrap; text-align: right">1033 μs</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap; text-align: right">1.34 K</td>
    <td style="white-space: nowrap; text-align: right">747.23 μs</td>
    <td style="white-space: nowrap; text-align: right">±37.52%</td>
    <td style="white-space: nowrap; text-align: right">694 μs</td>
    <td style="white-space: nowrap; text-align: right">1468.71 μs</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">0.0573 K</td>
    <td style="white-space: nowrap; text-align: right">17450.08 μs</td>
    <td style="white-space: nowrap; text-align: right">±9.52%</td>
    <td style="white-space: nowrap; text-align: right">16912 μs</td>
    <td style="white-space: nowrap; text-align: right">24680.98 μs</td>
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
    <td style="white-space: nowrap;text-align: right">1.36 K</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap; text-align: right">1.34 K</td>
    <td style="white-space: nowrap; text-align: right">1.01x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">0.0573 K</td>
    <td style="white-space: nowrap; text-align: right">23.67x</td>
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
    <td style="white-space: nowrap">122.64 KB</td>
    <td>0.66x</td>
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
    <td style="white-space: nowrap; text-align: right">1165.88</td>
    <td style="white-space: nowrap; text-align: right">0.86 ms</td>
    <td style="white-space: nowrap; text-align: right">±68.39%</td>
    <td style="white-space: nowrap; text-align: right">0.79 ms</td>
    <td style="white-space: nowrap; text-align: right">1.73 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap; text-align: right">319.59</td>
    <td style="white-space: nowrap; text-align: right">3.13 ms</td>
    <td style="white-space: nowrap; text-align: right">±24.96%</td>
    <td style="white-space: nowrap; text-align: right">2.93 ms</td>
    <td style="white-space: nowrap; text-align: right">5.98 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">8.84</td>
    <td style="white-space: nowrap; text-align: right">113.07 ms</td>
    <td style="white-space: nowrap; text-align: right">±7.11%</td>
    <td style="white-space: nowrap; text-align: right">110.16 ms</td>
    <td style="white-space: nowrap; text-align: right">152.14 ms</td>
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
    <td style="white-space: nowrap;text-align: right">1165.88</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap; text-align: right">319.59</td>
    <td style="white-space: nowrap; text-align: right">3.65x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">8.84</td>
    <td style="white-space: nowrap; text-align: right">131.82x</td>
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
    <td style="white-space: nowrap">675.83 KB</td>
    <td>3.36x</td>
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
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap; text-align: right">1.37 K</td>
    <td style="white-space: nowrap; text-align: right">729.81 μs</td>
    <td style="white-space: nowrap; text-align: right">±25.12%</td>
    <td style="white-space: nowrap; text-align: right">701 μs</td>
    <td style="white-space: nowrap; text-align: right">1178 μs</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info</td>
    <td style="white-space: nowrap; text-align: right">1.20 K</td>
    <td style="white-space: nowrap; text-align: right">834.59 μs</td>
    <td style="white-space: nowrap; text-align: right">±31.14%</td>
    <td style="white-space: nowrap; text-align: right">794 μs</td>
    <td style="white-space: nowrap; text-align: right">1399.56 μs</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">0.0704 K</td>
    <td style="white-space: nowrap; text-align: right">14201.00 μs</td>
    <td style="white-space: nowrap; text-align: right">±12.76%</td>
    <td style="white-space: nowrap; text-align: right">13620 μs</td>
    <td style="white-space: nowrap; text-align: right">22367.45 μs</td>
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
    <td style="white-space: nowrap;text-align: right">1.37 K</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info</td>
    <td style="white-space: nowrap; text-align: right">1.20 K</td>
    <td style="white-space: nowrap; text-align: right">1.14x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">0.0704 K</td>
    <td style="white-space: nowrap; text-align: right">19.46x</td>
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
    <td style="white-space: nowrap">104.38 KB</td>
      <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info</td>
    <td style="white-space: nowrap">164.39 KB</td>
    <td>1.57x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap">970.55 KB</td>
    <td>9.3x</td>
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
    <td style="white-space: nowrap; text-align: right">138.13</td>
    <td style="white-space: nowrap; text-align: right">7.24 ms</td>
    <td style="white-space: nowrap; text-align: right">±17.05%</td>
    <td style="white-space: nowrap; text-align: right">6.96 ms</td>
    <td style="white-space: nowrap; text-align: right">15.35 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap; text-align: right">90.52</td>
    <td style="white-space: nowrap; text-align: right">11.05 ms</td>
    <td style="white-space: nowrap; text-align: right">±12.53%</td>
    <td style="white-space: nowrap; text-align: right">10.61 ms</td>
    <td style="white-space: nowrap; text-align: right">17.41 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">64.18</td>
    <td style="white-space: nowrap; text-align: right">15.58 ms</td>
    <td style="white-space: nowrap; text-align: right">±12.69%</td>
    <td style="white-space: nowrap; text-align: right">14.95 ms</td>
    <td style="white-space: nowrap; text-align: right">23.87 ms</td>
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
    <td style="white-space: nowrap;text-align: right">138.13</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap; text-align: right">90.52</td>
    <td style="white-space: nowrap; text-align: right">1.53x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">64.18</td>
    <td style="white-space: nowrap; text-align: right">2.15x</td>
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
    <td style="white-space: nowrap">1.09 MB</td>
      <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap">1.43 MB</td>
    <td>1.31x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap">2.35 MB</td>
    <td>2.15x</td>
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
    <td style="white-space: nowrap; text-align: right">87.00</td>
    <td style="white-space: nowrap; text-align: right">11.49 ms</td>
    <td style="white-space: nowrap; text-align: right">±15.48%</td>
    <td style="white-space: nowrap; text-align: right">10.98 ms</td>
    <td style="white-space: nowrap; text-align: right">19.93 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap; text-align: right">58.40</td>
    <td style="white-space: nowrap; text-align: right">17.12 ms</td>
    <td style="white-space: nowrap; text-align: right">±13.41%</td>
    <td style="white-space: nowrap; text-align: right">16.47 ms</td>
    <td style="white-space: nowrap; text-align: right">27.87 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">9.07</td>
    <td style="white-space: nowrap; text-align: right">110.21 ms</td>
    <td style="white-space: nowrap; text-align: right">±5.13%</td>
    <td style="white-space: nowrap; text-align: right">108.62 ms</td>
    <td style="white-space: nowrap; text-align: right">133.47 ms</td>
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
    <td style="white-space: nowrap;text-align: right">87.00</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap; text-align: right">58.40</td>
    <td style="white-space: nowrap; text-align: right">1.49x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">9.07</td>
    <td style="white-space: nowrap; text-align: right">9.59x</td>
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
    <td style="white-space: nowrap">1.74 MB</td>
      <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap">2.46 MB</td>
    <td>1.41x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap">42.96 MB</td>
    <td>24.63x</td>
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
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap; text-align: right">1.68 K</td>
    <td style="white-space: nowrap; text-align: right">595.35 μs</td>
    <td style="white-space: nowrap; text-align: right">±35.95%</td>
    <td style="white-space: nowrap; text-align: right">560 μs</td>
    <td style="white-space: nowrap; text-align: right">1072.88 μs</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info</td>
    <td style="white-space: nowrap; text-align: right">1.27 K</td>
    <td style="white-space: nowrap; text-align: right">788.70 μs</td>
    <td style="white-space: nowrap; text-align: right">±39.85%</td>
    <td style="white-space: nowrap; text-align: right">724 μs</td>
    <td style="white-space: nowrap; text-align: right">1615.24 μs</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">0.123 K</td>
    <td style="white-space: nowrap; text-align: right">8129.34 μs</td>
    <td style="white-space: nowrap; text-align: right">±17.83%</td>
    <td style="white-space: nowrap; text-align: right">7719 μs</td>
    <td style="white-space: nowrap; text-align: right">14603.45 μs</td>
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
    <td style="white-space: nowrap;text-align: right">1.68 K</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info</td>
    <td style="white-space: nowrap; text-align: right">1.27 K</td>
    <td style="white-space: nowrap; text-align: right">1.32x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">0.123 K</td>
    <td style="white-space: nowrap; text-align: right">13.65x</td>
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
    <td style="white-space: nowrap">109.14 KB</td>
      <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info</td>
    <td style="white-space: nowrap">176.66 KB</td>
    <td>1.62x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap">2456.16 KB</td>
    <td>22.5x</td>
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
    <td style="white-space: nowrap; text-align: right">419.80</td>
    <td style="white-space: nowrap; text-align: right">2.38 ms</td>
    <td style="white-space: nowrap; text-align: right">±29.75%</td>
    <td style="white-space: nowrap; text-align: right">2.23 ms</td>
    <td style="white-space: nowrap; text-align: right">4.66 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap; text-align: right">288.07</td>
    <td style="white-space: nowrap; text-align: right">3.47 ms</td>
    <td style="white-space: nowrap; text-align: right">±18.52%</td>
    <td style="white-space: nowrap; text-align: right">3.31 ms</td>
    <td style="white-space: nowrap; text-align: right">6.00 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">128.85</td>
    <td style="white-space: nowrap; text-align: right">7.76 ms</td>
    <td style="white-space: nowrap; text-align: right">±16.41%</td>
    <td style="white-space: nowrap; text-align: right">7.40 ms</td>
    <td style="white-space: nowrap; text-align: right">13.86 ms</td>
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
    <td style="white-space: nowrap;text-align: right">419.80</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap; text-align: right">288.07</td>
    <td style="white-space: nowrap; text-align: right">1.46x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">128.85</td>
    <td style="white-space: nowrap; text-align: right">3.26x</td>
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
    <td style="white-space: nowrap">385.91 KB</td>
    <td>1.02x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap">1787.70 KB</td>
    <td>4.72x</td>
  </tr>
</table>
<hr/>
