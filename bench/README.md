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
    <td style="white-space: nowrap">time_zone_info</td>
    <td style="white-space: nowrap; text-align: right">2.49 K</td>
    <td style="white-space: nowrap; text-align: right">402.22 μs</td>
    <td style="white-space: nowrap; text-align: right">±14.47%</td>
    <td style="white-space: nowrap; text-align: right">389 μs</td>
    <td style="white-space: nowrap; text-align: right">595 μs</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap; text-align: right">1.94 K</td>
    <td style="white-space: nowrap; text-align: right">516.38 μs</td>
    <td style="white-space: nowrap; text-align: right">±21.04%</td>
    <td style="white-space: nowrap; text-align: right">494 μs</td>
    <td style="white-space: nowrap; text-align: right">957 μs</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">0.0739 K</td>
    <td style="white-space: nowrap; text-align: right">13540.14 μs</td>
    <td style="white-space: nowrap; text-align: right">±3.11%</td>
    <td style="white-space: nowrap; text-align: right">13441 μs</td>
    <td style="white-space: nowrap; text-align: right">15366.00 μs</td>
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
    <td style="white-space: nowrap;text-align: right">2.49 K</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap; text-align: right">1.94 K</td>
    <td style="white-space: nowrap; text-align: right">1.28x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">0.0739 K</td>
    <td style="white-space: nowrap; text-align: right">33.66x</td>
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
    <td style="white-space: nowrap">1763.87 KB</td>
    <td>9.52x</td>
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
    <td style="white-space: nowrap; text-align: right">2.45 K</td>
    <td style="white-space: nowrap; text-align: right">407.71 μs</td>
    <td style="white-space: nowrap; text-align: right">±10.60%</td>
    <td style="white-space: nowrap; text-align: right">394 μs</td>
    <td style="white-space: nowrap; text-align: right">567 μs</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap; text-align: right">1.92 K</td>
    <td style="white-space: nowrap; text-align: right">520.90 μs</td>
    <td style="white-space: nowrap; text-align: right">±16.79%</td>
    <td style="white-space: nowrap; text-align: right">497 μs</td>
    <td style="white-space: nowrap; text-align: right">868.49 μs</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">0.0157 K</td>
    <td style="white-space: nowrap; text-align: right">63498.37 μs</td>
    <td style="white-space: nowrap; text-align: right">±3.59%</td>
    <td style="white-space: nowrap; text-align: right">62897.50 μs</td>
    <td style="white-space: nowrap; text-align: right">74624.63 μs</td>
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
    <td style="white-space: nowrap;text-align: right">2.45 K</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap; text-align: right">1.92 K</td>
    <td style="white-space: nowrap; text-align: right">1.28x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">0.0157 K</td>
    <td style="white-space: nowrap; text-align: right">155.74x</td>
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
    <td style="white-space: nowrap">47367.83 KB</td>
    <td>235.75x</td>
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
    <td style="white-space: nowrap; text-align: right">2.54 K</td>
    <td style="white-space: nowrap; text-align: right">394.20 μs</td>
    <td style="white-space: nowrap; text-align: right">±12.08%</td>
    <td style="white-space: nowrap; text-align: right">382 μs</td>
    <td style="white-space: nowrap; text-align: right">578.06 μs</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap; text-align: right">2.04 K</td>
    <td style="white-space: nowrap; text-align: right">491.13 μs</td>
    <td style="white-space: nowrap; text-align: right">±11.48%</td>
    <td style="white-space: nowrap; text-align: right">484 μs</td>
    <td style="white-space: nowrap; text-align: right">686 μs</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">0.0900 K</td>
    <td style="white-space: nowrap; text-align: right">11105.76 μs</td>
    <td style="white-space: nowrap; text-align: right">±3.72%</td>
    <td style="white-space: nowrap; text-align: right">10986 μs</td>
    <td style="white-space: nowrap; text-align: right">12703.36 μs</td>
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
    <td style="white-space: nowrap;text-align: right">2.54 K</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap; text-align: right">2.04 K</td>
    <td style="white-space: nowrap; text-align: right">1.25x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">0.0900 K</td>
    <td style="white-space: nowrap; text-align: right">28.17x</td>
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
    <td style="white-space: nowrap">960.25 KB</td>
    <td>5.84x</td>
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
    <td style="white-space: nowrap; text-align: right">144.81</td>
    <td style="white-space: nowrap; text-align: right">6.91 ms</td>
    <td style="white-space: nowrap; text-align: right">±7.13%</td>
    <td style="white-space: nowrap; text-align: right">6.72 ms</td>
    <td style="white-space: nowrap; text-align: right">8.66 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap; text-align: right">109.40</td>
    <td style="white-space: nowrap; text-align: right">9.14 ms</td>
    <td style="white-space: nowrap; text-align: right">±6.99%</td>
    <td style="white-space: nowrap; text-align: right">8.89 ms</td>
    <td style="white-space: nowrap; text-align: right">11.24 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">93.96</td>
    <td style="white-space: nowrap; text-align: right">10.64 ms</td>
    <td style="white-space: nowrap; text-align: right">±5.69%</td>
    <td style="white-space: nowrap; text-align: right">10.44 ms</td>
    <td style="white-space: nowrap; text-align: right">12.80 ms</td>
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
    <td style="white-space: nowrap;text-align: right">144.81</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap; text-align: right">109.40</td>
    <td style="white-space: nowrap; text-align: right">1.32x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">93.96</td>
    <td style="white-space: nowrap; text-align: right">1.54x</td>
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
    <td style="white-space: nowrap">1.89 MB</td>
      <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap">2.85 MB</td>
    <td>1.51x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap">2.31 MB</td>
    <td>1.22x</td>
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
    <td style="white-space: nowrap; text-align: right">107.56</td>
    <td style="white-space: nowrap; text-align: right">9.30 ms</td>
    <td style="white-space: nowrap; text-align: right">±7.98%</td>
    <td style="white-space: nowrap; text-align: right">9.04 ms</td>
    <td style="white-space: nowrap; text-align: right">11.81 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap; text-align: right">84.34</td>
    <td style="white-space: nowrap; text-align: right">11.86 ms</td>
    <td style="white-space: nowrap; text-align: right">±5.18%</td>
    <td style="white-space: nowrap; text-align: right">11.60 ms</td>
    <td style="white-space: nowrap; text-align: right">13.89 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">17.37</td>
    <td style="white-space: nowrap; text-align: right">57.58 ms</td>
    <td style="white-space: nowrap; text-align: right">±4.18%</td>
    <td style="white-space: nowrap; text-align: right">56.77 ms</td>
    <td style="white-space: nowrap; text-align: right">65.41 ms</td>
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
    <td style="white-space: nowrap;text-align: right">107.56</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap; text-align: right">84.34</td>
    <td style="white-space: nowrap; text-align: right">1.28x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">17.37</td>
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
    <td style="white-space: nowrap">time_zone_info</td>
    <td style="white-space: nowrap">2.49 MB</td>
      <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap">3.73 MB</td>
    <td>1.5x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap">43.91 MB</td>
    <td>17.6x</td>
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
    <td style="white-space: nowrap; text-align: right">2.57 K</td>
    <td style="white-space: nowrap; text-align: right">388.51 μs</td>
    <td style="white-space: nowrap; text-align: right">±11.15%</td>
    <td style="white-space: nowrap; text-align: right">377 μs</td>
    <td style="white-space: nowrap; text-align: right">554 μs</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap; text-align: right">2.12 K</td>
    <td style="white-space: nowrap; text-align: right">472.54 μs</td>
    <td style="white-space: nowrap; text-align: right">±9.65%</td>
    <td style="white-space: nowrap; text-align: right">470 μs</td>
    <td style="white-space: nowrap; text-align: right">640 μs</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">0.199 K</td>
    <td style="white-space: nowrap; text-align: right">5013.75 μs</td>
    <td style="white-space: nowrap; text-align: right">±6.79%</td>
    <td style="white-space: nowrap; text-align: right">4895 μs</td>
    <td style="white-space: nowrap; text-align: right">6387.96 μs</td>
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
    <td style="white-space: nowrap;text-align: right">2.57 K</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap; text-align: right">2.12 K</td>
    <td style="white-space: nowrap; text-align: right">1.22x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">0.199 K</td>
    <td style="white-space: nowrap; text-align: right">12.91x</td>
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
    <td style="white-space: nowrap">172.14 KB</td>
      <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap">105.57 KB</td>
    <td>0.61x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap">1307.93 KB</td>
    <td>7.6x</td>
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
    <td style="white-space: nowrap; text-align: right">513.06</td>
    <td style="white-space: nowrap; text-align: right">1.95 ms</td>
    <td style="white-space: nowrap; text-align: right">±7.97%</td>
    <td style="white-space: nowrap; text-align: right">1.89 ms</td>
    <td style="white-space: nowrap; text-align: right">2.58 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap; text-align: right">425.02</td>
    <td style="white-space: nowrap; text-align: right">2.35 ms</td>
    <td style="white-space: nowrap; text-align: right">±7.72%</td>
    <td style="white-space: nowrap; text-align: right">2.28 ms</td>
    <td style="white-space: nowrap; text-align: right">3.13 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">181.32</td>
    <td style="white-space: nowrap; text-align: right">5.52 ms</td>
    <td style="white-space: nowrap; text-align: right">±7.40%</td>
    <td style="white-space: nowrap; text-align: right">5.36 ms</td>
    <td style="white-space: nowrap; text-align: right">7.23 ms</td>
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
    <td style="white-space: nowrap;text-align: right">513.06</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap; text-align: right">425.02</td>
    <td style="white-space: nowrap; text-align: right">1.21x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">181.32</td>
    <td style="white-space: nowrap; text-align: right">2.83x</td>
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
    <td style="white-space: nowrap">550.02 KB</td>
      <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap">724.83 KB</td>
    <td>1.32x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap">1798.76 KB</td>
    <td>3.27x</td>
  </tr>
</table>
<hr/>
