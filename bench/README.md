# Benchmark

This benchmark compares `TimeZoneInfo` with
[`Tzdata`](https://github.com/lau/tzdata) and
[`Tz`](https://github.com/mathieuprog/tz).

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
    <td style="white-space: nowrap">time_zone_info</td>
    <td style="white-space: nowrap; text-align: right">175.73</td>
    <td style="white-space: nowrap; text-align: right">5.69 ms</td>
    <td style="white-space: nowrap; text-align: right">±11.47%</td>
    <td style="white-space: nowrap; text-align: right">5.48 ms</td>
    <td style="white-space: nowrap; text-align: right">8.40 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap; text-align: right">103.51</td>
    <td style="white-space: nowrap; text-align: right">9.66 ms</td>
    <td style="white-space: nowrap; text-align: right">±5.44%</td>
    <td style="white-space: nowrap; text-align: right">9.60 ms</td>
    <td style="white-space: nowrap; text-align: right">11.40 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">82.09</td>
    <td style="white-space: nowrap; text-align: right">12.18 ms</td>
    <td style="white-space: nowrap; text-align: right">±6.13%</td>
    <td style="white-space: nowrap; text-align: right">12.06 ms</td>
    <td style="white-space: nowrap; text-align: right">14.69 ms</td>
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
    <td style="white-space: nowrap;text-align: right">175.73</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap; text-align: right">103.51</td>
    <td style="white-space: nowrap; text-align: right">1.7x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">82.09</td>
    <td style="white-space: nowrap; text-align: right">2.14x</td>
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
    <td style="white-space: nowrap">3.78 MB</td>
      <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap">2.85 MB</td>
    <td>0.75x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap">2.31 MB</td>
    <td>0.61x</td>
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
    <td style="white-space: nowrap; text-align: right">1955.29</td>
    <td style="white-space: nowrap; text-align: right">0.51 ms</td>
    <td style="white-space: nowrap; text-align: right">±11.07%</td>
    <td style="white-space: nowrap; text-align: right">0.49 ms</td>
    <td style="white-space: nowrap; text-align: right">0.74 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info</td>
    <td style="white-space: nowrap; text-align: right">320.93</td>
    <td style="white-space: nowrap; text-align: right">3.12 ms</td>
    <td style="white-space: nowrap; text-align: right">±11.30%</td>
    <td style="white-space: nowrap; text-align: right">3.01 ms</td>
    <td style="white-space: nowrap; text-align: right">4.72 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">74.12</td>
    <td style="white-space: nowrap; text-align: right">13.49 ms</td>
    <td style="white-space: nowrap; text-align: right">±6.32%</td>
    <td style="white-space: nowrap; text-align: right">13.44 ms</td>
    <td style="white-space: nowrap; text-align: right">17.32 ms</td>
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
    <td style="white-space: nowrap;text-align: right">1955.29</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info</td>
    <td style="white-space: nowrap; text-align: right">320.93</td>
    <td style="white-space: nowrap; text-align: right">6.09x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">74.12</td>
    <td style="white-space: nowrap; text-align: right">26.38x</td>
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
    <td style="white-space: nowrap">time_zone_info</td>
    <td style="white-space: nowrap">3.08 MB</td>
    <td>28.75x</td>
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
    <td style="white-space: nowrap; text-align: right">1917.08</td>
    <td style="white-space: nowrap; text-align: right">0.52 ms</td>
    <td style="white-space: nowrap; text-align: right">±10.78%</td>
    <td style="white-space: nowrap; text-align: right">0.50 ms</td>
    <td style="white-space: nowrap; text-align: right">0.74 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info</td>
    <td style="white-space: nowrap; text-align: right">201.83</td>
    <td style="white-space: nowrap; text-align: right">4.95 ms</td>
    <td style="white-space: nowrap; text-align: right">±7.13%</td>
    <td style="white-space: nowrap; text-align: right">4.85 ms</td>
    <td style="white-space: nowrap; text-align: right">6.18 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">15.20</td>
    <td style="white-space: nowrap; text-align: right">65.80 ms</td>
    <td style="white-space: nowrap; text-align: right">±3.25%</td>
    <td style="white-space: nowrap; text-align: right">65.02 ms</td>
    <td style="white-space: nowrap; text-align: right">73.98 ms</td>
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
    <td style="white-space: nowrap;text-align: right">1917.08</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info</td>
    <td style="white-space: nowrap; text-align: right">201.83</td>
    <td style="white-space: nowrap; text-align: right">9.5x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">15.20</td>
    <td style="white-space: nowrap; text-align: right">126.14x</td>
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
    <td style="white-space: nowrap">time_zone_info</td>
    <td style="white-space: nowrap">3.31 MB</td>
    <td>28.2x</td>
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
    <td style="white-space: nowrap">time_zone_info</td>
    <td style="white-space: nowrap; text-align: right">116.80</td>
    <td style="white-space: nowrap; text-align: right">8.56 ms</td>
    <td style="white-space: nowrap; text-align: right">±10.65%</td>
    <td style="white-space: nowrap; text-align: right">8.39 ms</td>
    <td style="white-space: nowrap; text-align: right">12.33 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap; text-align: right">79.25</td>
    <td style="white-space: nowrap; text-align: right">12.62 ms</td>
    <td style="white-space: nowrap; text-align: right">±6.22%</td>
    <td style="white-space: nowrap; text-align: right">12.52 ms</td>
    <td style="white-space: nowrap; text-align: right">15.72 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">15.36</td>
    <td style="white-space: nowrap; text-align: right">65.12 ms</td>
    <td style="white-space: nowrap; text-align: right">±3.82%</td>
    <td style="white-space: nowrap; text-align: right">64.22 ms</td>
    <td style="white-space: nowrap; text-align: right">74.09 ms</td>
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
    <td style="white-space: nowrap;text-align: right">116.80</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap; text-align: right">79.25</td>
    <td style="white-space: nowrap; text-align: right">1.47x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">15.36</td>
    <td style="white-space: nowrap; text-align: right">7.61x</td>
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
    <td style="white-space: nowrap">4.24 MB</td>
      <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap">3.73 MB</td>
    <td>0.88x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap">43.95 MB</td>
    <td>10.37x</td>
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
    <td style="white-space: nowrap; text-align: right">1965.08</td>
    <td style="white-space: nowrap; text-align: right">0.51 ms</td>
    <td style="white-space: nowrap; text-align: right">±18.01%</td>
    <td style="white-space: nowrap; text-align: right">0.48 ms</td>
    <td style="white-space: nowrap; text-align: right">0.90 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info</td>
    <td style="white-space: nowrap; text-align: right">489.57</td>
    <td style="white-space: nowrap; text-align: right">2.04 ms</td>
    <td style="white-space: nowrap; text-align: right">±13.60%</td>
    <td style="white-space: nowrap; text-align: right">1.95 ms</td>
    <td style="white-space: nowrap; text-align: right">3.16 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">176.99</td>
    <td style="white-space: nowrap; text-align: right">5.65 ms</td>
    <td style="white-space: nowrap; text-align: right">±8.28%</td>
    <td style="white-space: nowrap; text-align: right">5.50 ms</td>
    <td style="white-space: nowrap; text-align: right">7.47 ms</td>
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
    <td style="white-space: nowrap;text-align: right">1965.08</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info</td>
    <td style="white-space: nowrap; text-align: right">489.57</td>
    <td style="white-space: nowrap; text-align: right">4.01x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">176.99</td>
    <td style="white-space: nowrap; text-align: right">11.1x</td>
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
    <td style="white-space: nowrap">time_zone_info</td>
    <td style="white-space: nowrap">1.58 MB</td>
    <td>15.27x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap">1.45 MB</td>
    <td>14.05x</td>
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
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap; text-align: right">400.18</td>
    <td style="white-space: nowrap; text-align: right">2.50 ms</td>
    <td style="white-space: nowrap; text-align: right">±9.39%</td>
    <td style="white-space: nowrap; text-align: right">2.43 ms</td>
    <td style="white-space: nowrap; text-align: right">3.45 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info</td>
    <td style="white-space: nowrap; text-align: right">349.35</td>
    <td style="white-space: nowrap; text-align: right">2.86 ms</td>
    <td style="white-space: nowrap; text-align: right">±11.86%</td>
    <td style="white-space: nowrap; text-align: right">2.75 ms</td>
    <td style="white-space: nowrap; text-align: right">4.26 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">175.81</td>
    <td style="white-space: nowrap; text-align: right">5.69 ms</td>
    <td style="white-space: nowrap; text-align: right">±10.07%</td>
    <td style="white-space: nowrap; text-align: right">5.54 ms</td>
    <td style="white-space: nowrap; text-align: right">7.91 ms</td>
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
    <td style="white-space: nowrap;text-align: right">400.18</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info</td>
    <td style="white-space: nowrap; text-align: right">349.35</td>
    <td style="white-space: nowrap; text-align: right">1.15x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">175.81</td>
    <td style="white-space: nowrap; text-align: right">2.28x</td>
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
    <td style="white-space: nowrap">0.71 MB</td>
      <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info</td>
    <td style="white-space: nowrap">1.96 MB</td>
    <td>2.77x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap">1.76 MB</td>
    <td>2.48x</td>
  </tr>
</table>
<hr/>
