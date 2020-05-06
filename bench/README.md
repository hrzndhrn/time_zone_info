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
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap; text-align: right">2.04 K</td>
    <td style="white-space: nowrap; text-align: right">490.71 μs</td>
    <td style="white-space: nowrap; text-align: right">±7.00%</td>
    <td style="white-space: nowrap; text-align: right">494 μs</td>
    <td style="white-space: nowrap; text-align: right">622 μs</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info</td>
    <td style="white-space: nowrap; text-align: right">1.87 K</td>
    <td style="white-space: nowrap; text-align: right">535.61 μs</td>
    <td style="white-space: nowrap; text-align: right">±6.90%</td>
    <td style="white-space: nowrap; text-align: right">527 μs</td>
    <td style="white-space: nowrap; text-align: right">674.75 μs</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">0.0803 K</td>
    <td style="white-space: nowrap; text-align: right">12460.98 μs</td>
    <td style="white-space: nowrap; text-align: right">±2.98%</td>
    <td style="white-space: nowrap; text-align: right">12329 μs</td>
    <td style="white-space: nowrap; text-align: right">13745.36 μs</td>
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
    <td style="white-space: nowrap;text-align: right">2.04 K</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info</td>
    <td style="white-space: nowrap; text-align: right">1.87 K</td>
    <td style="white-space: nowrap; text-align: right">1.09x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">0.0803 K</td>
    <td style="white-space: nowrap; text-align: right">25.39x</td>
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
    <td style="white-space: nowrap">109.59 KB</td>
      <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info</td>
    <td style="white-space: nowrap">318.20 KB</td>
    <td>2.9x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap">1763.87 KB</td>
    <td>16.09x</td>
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
    <td style="white-space: nowrap; text-align: right">2022.01</td>
    <td style="white-space: nowrap; text-align: right">0.49 ms</td>
    <td style="white-space: nowrap; text-align: right">±6.23%</td>
    <td style="white-space: nowrap; text-align: right">0.50 ms</td>
    <td style="white-space: nowrap; text-align: right">0.63 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info</td>
    <td style="white-space: nowrap; text-align: right">567.15</td>
    <td style="white-space: nowrap; text-align: right">1.76 ms</td>
    <td style="white-space: nowrap; text-align: right">±5.78%</td>
    <td style="white-space: nowrap; text-align: right">1.72 ms</td>
    <td style="white-space: nowrap; text-align: right">2.15 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">15.95</td>
    <td style="white-space: nowrap; text-align: right">62.70 ms</td>
    <td style="white-space: nowrap; text-align: right">±2.58%</td>
    <td style="white-space: nowrap; text-align: right">62.21 ms</td>
    <td style="white-space: nowrap; text-align: right">69.00 ms</td>
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
    <td style="white-space: nowrap;text-align: right">2022.01</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info</td>
    <td style="white-space: nowrap; text-align: right">567.15</td>
    <td style="white-space: nowrap; text-align: right">3.57x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">15.95</td>
    <td style="white-space: nowrap; text-align: right">126.79x</td>
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
    <td style="white-space: nowrap">868.88 KB</td>
    <td>7.24x</td>
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
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap; text-align: right">2.06 K</td>
    <td style="white-space: nowrap; text-align: right">486.00 μs</td>
    <td style="white-space: nowrap; text-align: right">±9.77%</td>
    <td style="white-space: nowrap; text-align: right">481 μs</td>
    <td style="white-space: nowrap; text-align: right">673 μs</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info</td>
    <td style="white-space: nowrap; text-align: right">1.85 K</td>
    <td style="white-space: nowrap; text-align: right">541.36 μs</td>
    <td style="white-space: nowrap; text-align: right">±7.19%</td>
    <td style="white-space: nowrap; text-align: right">532 μs</td>
    <td style="white-space: nowrap; text-align: right">680 μs</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">0.0889 K</td>
    <td style="white-space: nowrap; text-align: right">11244.54 μs</td>
    <td style="white-space: nowrap; text-align: right">±7.31%</td>
    <td style="white-space: nowrap; text-align: right">11098 μs</td>
    <td style="white-space: nowrap; text-align: right">13358 μs</td>
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
    <td style="white-space: nowrap;text-align: right">2.06 K</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info</td>
    <td style="white-space: nowrap; text-align: right">1.85 K</td>
    <td style="white-space: nowrap; text-align: right">1.11x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">0.0889 K</td>
    <td style="white-space: nowrap; text-align: right">23.14x</td>
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
    <td style="white-space: nowrap">101.74 KB</td>
      <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info</td>
    <td style="white-space: nowrap">307.91 KB</td>
    <td>3.03x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap">960.25 KB</td>
    <td>9.44x</td>
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
    <td style="white-space: nowrap; text-align: right">407.99</td>
    <td style="white-space: nowrap; text-align: right">2.45 ms</td>
    <td style="white-space: nowrap; text-align: right">±9.13%</td>
    <td style="white-space: nowrap; text-align: right">2.38 ms</td>
    <td style="white-space: nowrap; text-align: right">3.32 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap; text-align: right">107.76</td>
    <td style="white-space: nowrap; text-align: right">9.28 ms</td>
    <td style="white-space: nowrap; text-align: right">±9.29%</td>
    <td style="white-space: nowrap; text-align: right">9.04 ms</td>
    <td style="white-space: nowrap; text-align: right">14.60 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">89.69</td>
    <td style="white-space: nowrap; text-align: right">11.15 ms</td>
    <td style="white-space: nowrap; text-align: right">±6.18%</td>
    <td style="white-space: nowrap; text-align: right">10.94 ms</td>
    <td style="white-space: nowrap; text-align: right">13.58 ms</td>
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
    <td style="white-space: nowrap;text-align: right">407.99</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap; text-align: right">107.76</td>
    <td style="white-space: nowrap; text-align: right">3.79x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">89.69</td>
    <td style="white-space: nowrap; text-align: right">4.55x</td>
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
    <td style="white-space: nowrap">0.94 MB</td>
      <td>&nbsp;</td>
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
    <td style="white-space: nowrap; text-align: right">217.23</td>
    <td style="white-space: nowrap; text-align: right">4.60 ms</td>
    <td style="white-space: nowrap; text-align: right">±3.09%</td>
    <td style="white-space: nowrap; text-align: right">4.56 ms</td>
    <td style="white-space: nowrap; text-align: right">5.19 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap; text-align: right">83.92</td>
    <td style="white-space: nowrap; text-align: right">11.92 ms</td>
    <td style="white-space: nowrap; text-align: right">±4.61%</td>
    <td style="white-space: nowrap; text-align: right">11.76 ms</td>
    <td style="white-space: nowrap; text-align: right">13.63 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">17.71</td>
    <td style="white-space: nowrap; text-align: right">56.48 ms</td>
    <td style="white-space: nowrap; text-align: right">±1.38%</td>
    <td style="white-space: nowrap; text-align: right">56.33 ms</td>
    <td style="white-space: nowrap; text-align: right">59.25 ms</td>
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
    <td style="white-space: nowrap;text-align: right">217.23</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap; text-align: right">83.92</td>
    <td style="white-space: nowrap; text-align: right">2.59x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">17.71</td>
    <td style="white-space: nowrap; text-align: right">12.27x</td>
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
    <td style="white-space: nowrap">1.44 MB</td>
      <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap">3.73 MB</td>
    <td>2.6x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap">43.91 MB</td>
    <td>30.55x</td>
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
    <td style="white-space: nowrap; text-align: right">2.03 K</td>
    <td style="white-space: nowrap; text-align: right">493.29 μs</td>
    <td style="white-space: nowrap; text-align: right">±8.42%</td>
    <td style="white-space: nowrap; text-align: right">476 μs</td>
    <td style="white-space: nowrap; text-align: right">659 μs</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap; text-align: right">1.96 K</td>
    <td style="white-space: nowrap; text-align: right">509.22 μs</td>
    <td style="white-space: nowrap; text-align: right">±24.87%</td>
    <td style="white-space: nowrap; text-align: right">475 μs</td>
    <td style="white-space: nowrap; text-align: right">992 μs</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">0.196 K</td>
    <td style="white-space: nowrap; text-align: right">5114.76 μs</td>
    <td style="white-space: nowrap; text-align: right">±3.97%</td>
    <td style="white-space: nowrap; text-align: right">5080 μs</td>
    <td style="white-space: nowrap; text-align: right">5853.15 μs</td>
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
    <td style="white-space: nowrap;text-align: right">2.03 K</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap; text-align: right">1.96 K</td>
    <td style="white-space: nowrap; text-align: right">1.03x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">0.196 K</td>
    <td style="white-space: nowrap; text-align: right">10.37x</td>
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
    <td style="white-space: nowrap">259.77 KB</td>
      <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap">105.82 KB</td>
    <td>0.41x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap">1419.88 KB</td>
    <td>5.47x</td>
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
    <td style="white-space: nowrap; text-align: right">844.89</td>
    <td style="white-space: nowrap; text-align: right">1.18 ms</td>
    <td style="white-space: nowrap; text-align: right">±6.15%</td>
    <td style="white-space: nowrap; text-align: right">1.17 ms</td>
    <td style="white-space: nowrap; text-align: right">1.48 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap; text-align: right">323.99</td>
    <td style="white-space: nowrap; text-align: right">3.09 ms</td>
    <td style="white-space: nowrap; text-align: right">±37.39%</td>
    <td style="white-space: nowrap; text-align: right">2.69 ms</td>
    <td style="white-space: nowrap; text-align: right">7.48 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">183.39</td>
    <td style="white-space: nowrap; text-align: right">5.45 ms</td>
    <td style="white-space: nowrap; text-align: right">±3.86%</td>
    <td style="white-space: nowrap; text-align: right">5.41 ms</td>
    <td style="white-space: nowrap; text-align: right">6.33 ms</td>
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
    <td style="white-space: nowrap;text-align: right">844.89</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap; text-align: right">323.99</td>
    <td style="white-space: nowrap; text-align: right">2.61x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">183.39</td>
    <td style="white-space: nowrap; text-align: right">4.61x</td>
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
    <td style="white-space: nowrap">568.46 KB</td>
      <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap">724.83 KB</td>
    <td>1.28x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap">1798.76 KB</td>
    <td>3.16x</td>
  </tr>
</table>
<hr/>
