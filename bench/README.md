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
    <td style="white-space: nowrap; text-align: right">2.65 K</td>
    <td style="white-space: nowrap; text-align: right">376.81 μs</td>
    <td style="white-space: nowrap; text-align: right">±5.07%</td>
    <td style="white-space: nowrap; text-align: right">376.98 μs</td>
    <td style="white-space: nowrap; text-align: right">451.98 μs</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap; text-align: right">2.10 K</td>
    <td style="white-space: nowrap; text-align: right">476.58 μs</td>
    <td style="white-space: nowrap; text-align: right">±5.11%</td>
    <td style="white-space: nowrap; text-align: right">482.98 μs</td>
    <td style="white-space: nowrap; text-align: right">575.98 μs</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">0.0731 K</td>
    <td style="white-space: nowrap; text-align: right">13680.87 μs</td>
    <td style="white-space: nowrap; text-align: right">±6.79%</td>
    <td style="white-space: nowrap; text-align: right">13426.98 μs</td>
    <td style="white-space: nowrap; text-align: right">18531.10 μs</td>
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
    <td style="white-space: nowrap;text-align: right">2.65 K</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap; text-align: right">2.10 K</td>
    <td style="white-space: nowrap; text-align: right">1.26x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">0.0731 K</td>
    <td style="white-space: nowrap; text-align: right">36.31x</td>
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
    <td style="white-space: nowrap">179.84 KB</td>
      <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap">109.59 KB</td>
    <td>0.61x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap">1763.87 KB</td>
    <td>9.81x</td>
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
    <td style="white-space: nowrap; text-align: right">2068.03</td>
    <td style="white-space: nowrap; text-align: right">0.48 ms</td>
    <td style="white-space: nowrap; text-align: right">±5.39%</td>
    <td style="white-space: nowrap; text-align: right">0.49 ms</td>
    <td style="white-space: nowrap; text-align: right">0.58 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info</td>
    <td style="white-space: nowrap; text-align: right">635.14</td>
    <td style="white-space: nowrap; text-align: right">1.57 ms</td>
    <td style="white-space: nowrap; text-align: right">±3.72%</td>
    <td style="white-space: nowrap; text-align: right">1.55 ms</td>
    <td style="white-space: nowrap; text-align: right">1.79 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">15.89</td>
    <td style="white-space: nowrap; text-align: right">62.95 ms</td>
    <td style="white-space: nowrap; text-align: right">±5.85%</td>
    <td style="white-space: nowrap; text-align: right">61.64 ms</td>
    <td style="white-space: nowrap; text-align: right">80.68 ms</td>
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
    <td style="white-space: nowrap;text-align: right">2068.03</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info</td>
    <td style="white-space: nowrap; text-align: right">635.14</td>
    <td style="white-space: nowrap; text-align: right">3.26x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">15.89</td>
    <td style="white-space: nowrap; text-align: right">130.19x</td>
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
    <td style="white-space: nowrap">120.03 KB</td>
      <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info</td>
    <td style="white-space: nowrap">722.77 KB</td>
    <td>6.02x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap">47367.83 KB</td>
    <td>394.63x</td>
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
    <td style="white-space: nowrap; text-align: right">2.73 K</td>
    <td style="white-space: nowrap; text-align: right">366.54 μs</td>
    <td style="white-space: nowrap; text-align: right">±4.43%</td>
    <td style="white-space: nowrap; text-align: right">368.98 μs</td>
    <td style="white-space: nowrap; text-align: right">433.98 μs</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap; text-align: right">2.16 K</td>
    <td style="white-space: nowrap; text-align: right">462.85 μs</td>
    <td style="white-space: nowrap; text-align: right">±4.77%</td>
    <td style="white-space: nowrap; text-align: right">456.98 μs</td>
    <td style="white-space: nowrap; text-align: right">544.98 μs</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">0.0914 K</td>
    <td style="white-space: nowrap; text-align: right">10935.97 μs</td>
    <td style="white-space: nowrap; text-align: right">±2.10%</td>
    <td style="white-space: nowrap; text-align: right">10881.98 μs</td>
    <td style="white-space: nowrap; text-align: right">12020.98 μs</td>
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
    <td style="white-space: nowrap;text-align: right">2.73 K</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap; text-align: right">2.16 K</td>
    <td style="white-space: nowrap; text-align: right">1.26x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">0.0914 K</td>
    <td style="white-space: nowrap; text-align: right">29.84x</td>
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
    <td style="white-space: nowrap">161.64 KB</td>
      <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap">101.74 KB</td>
    <td>0.63x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap">960.25 KB</td>
    <td>5.94x</td>
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
    <td style="white-space: nowrap; text-align: right">539.68</td>
    <td style="white-space: nowrap; text-align: right">1.85 ms</td>
    <td style="white-space: nowrap; text-align: right">±4.85%</td>
    <td style="white-space: nowrap; text-align: right">1.84 ms</td>
    <td style="white-space: nowrap; text-align: right">2.10 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap; text-align: right">114.65</td>
    <td style="white-space: nowrap; text-align: right">8.72 ms</td>
    <td style="white-space: nowrap; text-align: right">±1.83%</td>
    <td style="white-space: nowrap; text-align: right">8.68 ms</td>
    <td style="white-space: nowrap; text-align: right">9.45 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">96.14</td>
    <td style="white-space: nowrap; text-align: right">10.40 ms</td>
    <td style="white-space: nowrap; text-align: right">±5.31%</td>
    <td style="white-space: nowrap; text-align: right">10.28 ms</td>
    <td style="white-space: nowrap; text-align: right">12.54 ms</td>
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
    <td style="white-space: nowrap;text-align: right">539.68</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap; text-align: right">114.65</td>
    <td style="white-space: nowrap; text-align: right">4.71x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">96.14</td>
    <td style="white-space: nowrap; text-align: right">5.61x</td>
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
    <td style="white-space: nowrap">0.55 MB</td>
      <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap">2.85 MB</td>
    <td>5.2x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap">2.31 MB</td>
    <td>4.21x</td>
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
    <td style="white-space: nowrap; text-align: right">244.65</td>
    <td style="white-space: nowrap; text-align: right">4.09 ms</td>
    <td style="white-space: nowrap; text-align: right">±2.29%</td>
    <td style="white-space: nowrap; text-align: right">4.06 ms</td>
    <td style="white-space: nowrap; text-align: right">4.49 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap; text-align: right">88.13</td>
    <td style="white-space: nowrap; text-align: right">11.35 ms</td>
    <td style="white-space: nowrap; text-align: right">±1.47%</td>
    <td style="white-space: nowrap; text-align: right">11.31 ms</td>
    <td style="white-space: nowrap; text-align: right">11.95 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">16.72</td>
    <td style="white-space: nowrap; text-align: right">59.81 ms</td>
    <td style="white-space: nowrap; text-align: right">±1.42%</td>
    <td style="white-space: nowrap; text-align: right">59.58 ms</td>
    <td style="white-space: nowrap; text-align: right">63.41 ms</td>
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
    <td style="white-space: nowrap;text-align: right">244.65</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap; text-align: right">88.13</td>
    <td style="white-space: nowrap; text-align: right">2.78x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">16.72</td>
    <td style="white-space: nowrap; text-align: right">14.63x</td>
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
    <td style="white-space: nowrap">1.15 MB</td>
      <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap">3.73 MB</td>
    <td>3.25x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap">43.91 MB</td>
    <td>38.28x</td>
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
    <td style="white-space: nowrap; text-align: right">2.62 K</td>
    <td style="white-space: nowrap; text-align: right">381.50 μs</td>
    <td style="white-space: nowrap; text-align: right">±4.88%</td>
    <td style="white-space: nowrap; text-align: right">381.98 μs</td>
    <td style="white-space: nowrap; text-align: right">454.98 μs</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap; text-align: right">2.17 K</td>
    <td style="white-space: nowrap; text-align: right">461.23 μs</td>
    <td style="white-space: nowrap; text-align: right">±5.61%</td>
    <td style="white-space: nowrap; text-align: right">466.98 μs</td>
    <td style="white-space: nowrap; text-align: right">556.81 μs</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">0.185 K</td>
    <td style="white-space: nowrap; text-align: right">5401.67 μs</td>
    <td style="white-space: nowrap; text-align: right">±5.11%</td>
    <td style="white-space: nowrap; text-align: right">5296.98 μs</td>
    <td style="white-space: nowrap; text-align: right">6402.86 μs</td>
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
    <td style="white-space: nowrap;text-align: right">2.62 K</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap; text-align: right">2.17 K</td>
    <td style="white-space: nowrap; text-align: right">1.21x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">0.185 K</td>
    <td style="white-space: nowrap; text-align: right">14.16x</td>
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
    <td style="white-space: nowrap">170.16 KB</td>
      <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap">105.91 KB</td>
    <td>0.62x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap">1613.95 KB</td>
    <td>9.49x</td>
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
    <td style="white-space: nowrap; text-align: right">1252.26</td>
    <td style="white-space: nowrap; text-align: right">0.80 ms</td>
    <td style="white-space: nowrap; text-align: right">±4.39%</td>
    <td style="white-space: nowrap; text-align: right">0.79 ms</td>
    <td style="white-space: nowrap; text-align: right">0.93 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap; text-align: right">439.15</td>
    <td style="white-space: nowrap; text-align: right">2.28 ms</td>
    <td style="white-space: nowrap; text-align: right">±3.71%</td>
    <td style="white-space: nowrap; text-align: right">2.25 ms</td>
    <td style="white-space: nowrap; text-align: right">2.64 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">182.73</td>
    <td style="white-space: nowrap; text-align: right">5.47 ms</td>
    <td style="white-space: nowrap; text-align: right">±8.02%</td>
    <td style="white-space: nowrap; text-align: right">5.32 ms</td>
    <td style="white-space: nowrap; text-align: right">7.65 ms</td>
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
    <td style="white-space: nowrap;text-align: right">1252.26</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap; text-align: right">439.15</td>
    <td style="white-space: nowrap; text-align: right">2.85x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">182.73</td>
    <td style="white-space: nowrap; text-align: right">6.85x</td>
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
    <td style="white-space: nowrap">250.11 KB</td>
      <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap">724.83 KB</td>
    <td>2.9x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap">1798.76 KB</td>
    <td>7.19x</td>
  </tr>
</table>
<hr/>
