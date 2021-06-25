
# Benchmark

This benchmark compares `TimeZoneInfo` with
[`Tzdata`](https://github.com/lau/tzdata),
[`Tz`](https://github.com/mathieuprog/tz),
and [`zoneinfo`](https://github.com/smartrent/zoneinfo)

`TimeZoneInfo` is using
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
    <td style="white-space: nowrap">1.11.3</td>
  </tr><tr>
    <th style="white-space: nowrap">Erlang Version</th>
    <td style="white-space: nowrap">23.2</td>
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
    <td style="white-space: nowrap; text-align: right">1.57 K</td>
    <td style="white-space: nowrap; text-align: right">0.64 ms</td>
    <td style="white-space: nowrap; text-align: right">±4.74%</td>
    <td style="white-space: nowrap; text-align: right">0.63 ms</td>
    <td style="white-space: nowrap; text-align: right">0.75 ms</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">time_zone_info</td>
    <td style="white-space: nowrap; text-align: right">1.43 K</td>
    <td style="white-space: nowrap; text-align: right">0.70 ms</td>
    <td style="white-space: nowrap; text-align: right">±4.18%</td>
    <td style="white-space: nowrap; text-align: right">0.69 ms</td>
    <td style="white-space: nowrap; text-align: right">0.81 ms</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">0.0800 K</td>
    <td style="white-space: nowrap; text-align: right">12.50 ms</td>
    <td style="white-space: nowrap; text-align: right">±2.21%</td>
    <td style="white-space: nowrap; text-align: right">12.38 ms</td>
    <td style="white-space: nowrap; text-align: right">13.57 ms</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">zoneinfo</td>
    <td style="white-space: nowrap; text-align: right">0.0157 K</td>
    <td style="white-space: nowrap; text-align: right">63.78 ms</td>
    <td style="white-space: nowrap; text-align: right">±6.22%</td>
    <td style="white-space: nowrap; text-align: right">62.42 ms</td>
    <td style="white-space: nowrap; text-align: right">83.13 ms</td>
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
    <td style="white-space: nowrap;text-align: right">1.57 K</td>
    <td>&nbsp;</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">time_zone_info</td>
    <td style="white-space: nowrap; text-align: right">1.43 K</td>
    <td style="white-space: nowrap; text-align: right">1.09x</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">0.0800 K</td>
    <td style="white-space: nowrap; text-align: right">19.57x</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">zoneinfo</td>
    <td style="white-space: nowrap; text-align: right">0.0157 K</td>
    <td style="white-space: nowrap; text-align: right">99.85x</td>
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
    <td style="white-space: nowrap">0.145 MB</td>
<td>&nbsp;</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">time_zone_info</td>
    <td style="white-space: nowrap">0.21 MB</td>
    <td>1.42x</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap">1.61 MB</td>
    <td>11.09x</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">zoneinfo</td>
    <td style="white-space: nowrap">7.41 MB</td>
    <td>50.98x</td>
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
    <td style="white-space: nowrap; text-align: right">1395.66</td>
    <td style="white-space: nowrap; text-align: right">0.72 ms</td>
    <td style="white-space: nowrap; text-align: right">±3.70%</td>
    <td style="white-space: nowrap; text-align: right">0.71 ms</td>
    <td style="white-space: nowrap; text-align: right">0.83 ms</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap; text-align: right">546.48</td>
    <td style="white-space: nowrap; text-align: right">1.83 ms</td>
    <td style="white-space: nowrap; text-align: right">±4.55%</td>
    <td style="white-space: nowrap; text-align: right">1.80 ms</td>
    <td style="white-space: nowrap; text-align: right">2.25 ms</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">zoneinfo</td>
    <td style="white-space: nowrap; text-align: right">14.69</td>
    <td style="white-space: nowrap; text-align: right">68.06 ms</td>
    <td style="white-space: nowrap; text-align: right">±4.90%</td>
    <td style="white-space: nowrap; text-align: right">66.81 ms</td>
    <td style="white-space: nowrap; text-align: right">82.25 ms</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">10.71</td>
    <td style="white-space: nowrap; text-align: right">93.37 ms</td>
    <td style="white-space: nowrap; text-align: right">±2.12%</td>
    <td style="white-space: nowrap; text-align: right">92.60 ms</td>
    <td style="white-space: nowrap; text-align: right">101.58 ms</td>
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
    <td style="white-space: nowrap;text-align: right">1395.66</td>
    <td>&nbsp;</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap; text-align: right">546.48</td>
    <td style="white-space: nowrap; text-align: right">2.55x</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">zoneinfo</td>
    <td style="white-space: nowrap; text-align: right">14.69</td>
    <td style="white-space: nowrap; text-align: right">94.99x</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">10.71</td>
    <td style="white-space: nowrap; text-align: right">130.31x</td>
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
    <td style="white-space: nowrap">0.22 MB</td>
<td>&nbsp;</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap">0.60 MB</td>
    <td>2.7x</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">zoneinfo</td>
    <td style="white-space: nowrap">7.86 MB</td>
    <td>35.45x</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap">43.51 MB</td>
    <td>196.24x</td>
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
    <td style="white-space: nowrap; text-align: right">1.53 K</td>
    <td style="white-space: nowrap; text-align: right">0.65 ms</td>
    <td style="white-space: nowrap; text-align: right">±3.86%</td>
    <td style="white-space: nowrap; text-align: right">0.65 ms</td>
    <td style="white-space: nowrap; text-align: right">0.74 ms</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">time_zone_info</td>
    <td style="white-space: nowrap; text-align: right">1.45 K</td>
    <td style="white-space: nowrap; text-align: right">0.69 ms</td>
    <td style="white-space: nowrap; text-align: right">±3.57%</td>
    <td style="white-space: nowrap; text-align: right">0.68 ms</td>
    <td style="white-space: nowrap; text-align: right">0.78 ms</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">0.0961 K</td>
    <td style="white-space: nowrap; text-align: right">10.40 ms</td>
    <td style="white-space: nowrap; text-align: right">±2.57%</td>
    <td style="white-space: nowrap; text-align: right">10.29 ms</td>
    <td style="white-space: nowrap; text-align: right">11.55 ms</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">zoneinfo</td>
    <td style="white-space: nowrap; text-align: right">0.0155 K</td>
    <td style="white-space: nowrap; text-align: right">64.63 ms</td>
    <td style="white-space: nowrap; text-align: right">±5.09%</td>
    <td style="white-space: nowrap; text-align: right">63.39 ms</td>
    <td style="white-space: nowrap; text-align: right">77.77 ms</td>
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
    <td style="white-space: nowrap;text-align: right">1.53 K</td>
    <td>&nbsp;</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">time_zone_info</td>
    <td style="white-space: nowrap; text-align: right">1.45 K</td>
    <td style="white-space: nowrap; text-align: right">1.06x</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">0.0961 K</td>
    <td style="white-space: nowrap; text-align: right">15.93x</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">zoneinfo</td>
    <td style="white-space: nowrap; text-align: right">0.0155 K</td>
    <td style="white-space: nowrap; text-align: right">98.96x</td>
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
    <td style="white-space: nowrap">130.47 KB</td>
<td>&nbsp;</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">time_zone_info</td>
    <td style="white-space: nowrap">190.48 KB</td>
    <td>1.46x</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap">908.06 KB</td>
    <td>6.96x</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">zoneinfo</td>
    <td style="white-space: nowrap">7564.55 KB</td>
    <td>57.98x</td>
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
    <td style="white-space: nowrap; text-align: right">200.75</td>
    <td style="white-space: nowrap; text-align: right">4.98 ms</td>
    <td style="white-space: nowrap; text-align: right">±3.39%</td>
    <td style="white-space: nowrap; text-align: right">4.91 ms</td>
    <td style="white-space: nowrap; text-align: right">5.64 ms</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap; text-align: right">131.32</td>
    <td style="white-space: nowrap; text-align: right">7.61 ms</td>
    <td style="white-space: nowrap; text-align: right">±3.24%</td>
    <td style="white-space: nowrap; text-align: right">7.51 ms</td>
    <td style="white-space: nowrap; text-align: right">8.55 ms</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">93.88</td>
    <td style="white-space: nowrap; text-align: right">10.65 ms</td>
    <td style="white-space: nowrap; text-align: right">±4.15%</td>
    <td style="white-space: nowrap; text-align: right">10.45 ms</td>
    <td style="white-space: nowrap; text-align: right">12.35 ms</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">zoneinfo</td>
    <td style="white-space: nowrap; text-align: right">13.37</td>
    <td style="white-space: nowrap; text-align: right">74.78 ms</td>
    <td style="white-space: nowrap; text-align: right">±9.60%</td>
    <td style="white-space: nowrap; text-align: right">72.30 ms</td>
    <td style="white-space: nowrap; text-align: right">118.97 ms</td>
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
    <td style="white-space: nowrap;text-align: right">200.75</td>
    <td>&nbsp;</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap; text-align: right">131.32</td>
    <td style="white-space: nowrap; text-align: right">1.53x</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">93.88</td>
    <td style="white-space: nowrap; text-align: right">2.14x</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">zoneinfo</td>
    <td style="white-space: nowrap; text-align: right">13.37</td>
    <td style="white-space: nowrap; text-align: right">15.01x</td>
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
    <td style="white-space: nowrap">1.10 MB</td>
<td>&nbsp;</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap">1.34 MB</td>
    <td>1.22x</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap">2.28 MB</td>
    <td>2.07x</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">zoneinfo</td>
    <td style="white-space: nowrap">7.92 MB</td>
    <td>7.19x</td>
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
    <td style="white-space: nowrap; text-align: right">131.73</td>
    <td style="white-space: nowrap; text-align: right">7.59 ms</td>
    <td style="white-space: nowrap; text-align: right">±2.79%</td>
    <td style="white-space: nowrap; text-align: right">7.50 ms</td>
    <td style="white-space: nowrap; text-align: right">8.50 ms</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap; text-align: right">88.22</td>
    <td style="white-space: nowrap; text-align: right">11.34 ms</td>
    <td style="white-space: nowrap; text-align: right">±3.03%</td>
    <td style="white-space: nowrap; text-align: right">11.19 ms</td>
    <td style="white-space: nowrap; text-align: right">12.76 ms</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">zoneinfo</td>
    <td style="white-space: nowrap; text-align: right">12.94</td>
    <td style="white-space: nowrap; text-align: right">77.26 ms</td>
    <td style="white-space: nowrap; text-align: right">±4.15%</td>
    <td style="white-space: nowrap; text-align: right">75.83 ms</td>
    <td style="white-space: nowrap; text-align: right">90.68 ms</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">11.08</td>
    <td style="white-space: nowrap; text-align: right">90.23 ms</td>
    <td style="white-space: nowrap; text-align: right">±1.86%</td>
    <td style="white-space: nowrap; text-align: right">89.44 ms</td>
    <td style="white-space: nowrap; text-align: right">94.74 ms</td>
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
    <td style="white-space: nowrap;text-align: right">131.73</td>
    <td>&nbsp;</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap; text-align: right">88.22</td>
    <td style="white-space: nowrap; text-align: right">1.49x</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">zoneinfo</td>
    <td style="white-space: nowrap; text-align: right">12.94</td>
    <td style="white-space: nowrap; text-align: right">10.18x</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">11.08</td>
    <td style="white-space: nowrap; text-align: right">11.89x</td>
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
    <td style="white-space: nowrap">2.28 MB</td>
    <td>1.31x</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">zoneinfo</td>
    <td style="white-space: nowrap">8.66 MB</td>
    <td>4.97x</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap">42.22 MB</td>
    <td>24.25x</td>
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
    <td style="white-space: nowrap; text-align: right">2.02 K</td>
    <td style="white-space: nowrap; text-align: right">0.50 ms</td>
    <td style="white-space: nowrap; text-align: right">±4.58%</td>
    <td style="white-space: nowrap; text-align: right">0.49 ms</td>
    <td style="white-space: nowrap; text-align: right">0.58 ms</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">time_zone_info</td>
    <td style="white-space: nowrap; text-align: right">1.61 K</td>
    <td style="white-space: nowrap; text-align: right">0.62 ms</td>
    <td style="white-space: nowrap; text-align: right">±3.81%</td>
    <td style="white-space: nowrap; text-align: right">0.61 ms</td>
    <td style="white-space: nowrap; text-align: right">0.71 ms</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">0.161 K</td>
    <td style="white-space: nowrap; text-align: right">6.22 ms</td>
    <td style="white-space: nowrap; text-align: right">±4.90%</td>
    <td style="white-space: nowrap; text-align: right">6.07 ms</td>
    <td style="white-space: nowrap; text-align: right">7.26 ms</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">zoneinfo</td>
    <td style="white-space: nowrap; text-align: right">0.0167 K</td>
    <td style="white-space: nowrap; text-align: right">59.80 ms</td>
    <td style="white-space: nowrap; text-align: right">±5.69%</td>
    <td style="white-space: nowrap; text-align: right">58.30 ms</td>
    <td style="white-space: nowrap; text-align: right">71.08 ms</td>
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
    <td style="white-space: nowrap;text-align: right">2.02 K</td>
    <td>&nbsp;</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">time_zone_info</td>
    <td style="white-space: nowrap; text-align: right">1.61 K</td>
    <td style="white-space: nowrap; text-align: right">1.25x</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">0.161 K</td>
    <td style="white-space: nowrap; text-align: right">12.55x</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">zoneinfo</td>
    <td style="white-space: nowrap; text-align: right">0.0167 K</td>
    <td style="white-space: nowrap; text-align: right">120.72x</td>
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
    <td style="white-space: nowrap">0.132 MB</td>
<td>&nbsp;</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">time_zone_info</td>
    <td style="white-space: nowrap">0.198 MB</td>
    <td>1.5x</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap">2.36 MB</td>
    <td>17.84x</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">zoneinfo</td>
    <td style="white-space: nowrap">4.91 MB</td>
    <td>37.17x</td>
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
    <td style="white-space: nowrap; text-align: right">580.70</td>
    <td style="white-space: nowrap; text-align: right">1.72 ms</td>
    <td style="white-space: nowrap; text-align: right">±3.59%</td>
    <td style="white-space: nowrap; text-align: right">1.71 ms</td>
    <td style="white-space: nowrap; text-align: right">1.97 ms</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap; text-align: right">424.67</td>
    <td style="white-space: nowrap; text-align: right">2.35 ms</td>
    <td style="white-space: nowrap; text-align: right">±4.07%</td>
    <td style="white-space: nowrap; text-align: right">2.32 ms</td>
    <td style="white-space: nowrap; text-align: right">2.74 ms</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">178.39</td>
    <td style="white-space: nowrap; text-align: right">5.61 ms</td>
    <td style="white-space: nowrap; text-align: right">±7.48%</td>
    <td style="white-space: nowrap; text-align: right">5.47 ms</td>
    <td style="white-space: nowrap; text-align: right">7.72 ms</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">zoneinfo</td>
    <td style="white-space: nowrap; text-align: right">16.51</td>
    <td style="white-space: nowrap; text-align: right">60.58 ms</td>
    <td style="white-space: nowrap; text-align: right">±3.40%</td>
    <td style="white-space: nowrap; text-align: right">60.10 ms</td>
    <td style="white-space: nowrap; text-align: right">68.05 ms</td>
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
    <td style="white-space: nowrap;text-align: right">580.70</td>
    <td>&nbsp;</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap; text-align: right">424.67</td>
    <td style="white-space: nowrap; text-align: right">1.37x</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">178.39</td>
    <td style="white-space: nowrap; text-align: right">3.26x</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">zoneinfo</td>
    <td style="white-space: nowrap; text-align: right">16.51</td>
    <td style="white-space: nowrap; text-align: right">35.18x</td>
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
    <td style="white-space: nowrap">0.39 MB</td>
<td>&nbsp;</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap">0.35 MB</td>
    <td>0.91x</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap">1.75 MB</td>
    <td>4.47x</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">zoneinfo</td>
    <td style="white-space: nowrap">4.67 MB</td>
    <td>11.93x</td>
  </tr>

</table>


<hr/>

