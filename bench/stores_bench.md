
# Benchmark

This benchmark compares the different `DataStores` available in
`TimeZoneInfo`.

The `TimeZoneInfo` will be tested in three different configurations.
Each version uses a different strategy to keep the data available.
- `time_zone_info_pst` is using
  [`:persistent_term`](https://erlang.org/doc/man/persistent_term.html)
- `time_zone_info_ets` is using `:ets`
  [(Erlang Term Storage)](https://erlang.org/doc/man/ets.html)
- `time_zone_info_map` is using a `GenServer` with a `Map` as state. This
  version isn't an available configuration in `TimeZoneInfo`. The
  `GenServer` version is otherwise only used in the tests.

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
    <td style="white-space: nowrap">time_zone_info_pst</td>
    <td style="white-space: nowrap; text-align: right">1427.60</td>
    <td style="white-space: nowrap; text-align: right">0.70 ms</td>
    <td style="white-space: nowrap; text-align: right">±3.41%</td>
    <td style="white-space: nowrap; text-align: right">0.69 ms</td>
    <td style="white-space: nowrap; text-align: right">0.78 ms</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap; text-align: right">71.47</td>
    <td style="white-space: nowrap; text-align: right">13.99 ms</td>
    <td style="white-space: nowrap; text-align: right">±2.89%</td>
    <td style="white-space: nowrap; text-align: right">13.98 ms</td>
    <td style="white-space: nowrap; text-align: right">15.47 ms</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap; text-align: right">61.95</td>
    <td style="white-space: nowrap; text-align: right">16.14 ms</td>
    <td style="white-space: nowrap; text-align: right">±3.63%</td>
    <td style="white-space: nowrap; text-align: right">15.97 ms</td>
    <td style="white-space: nowrap; text-align: right">19.04 ms</td>
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
    <td style="white-space: nowrap;text-align: right">1427.60</td>
    <td>&nbsp;</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap; text-align: right">71.47</td>
    <td style="white-space: nowrap; text-align: right">19.98x</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap; text-align: right">61.95</td>
    <td style="white-space: nowrap; text-align: right">23.04x</td>
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
    <td style="white-space: nowrap">0.21 MB</td>
<td>&nbsp;</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap">15.74 MB</td>
    <td>76.19x</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap">15.77 MB</td>
    <td>76.34x</td>
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
    <td style="white-space: nowrap">time_zone_info_pst</td>
    <td style="white-space: nowrap; text-align: right">1378.65</td>
    <td style="white-space: nowrap; text-align: right">0.73 ms</td>
    <td style="white-space: nowrap; text-align: right">±4.74%</td>
    <td style="white-space: nowrap; text-align: right">0.71 ms</td>
    <td style="white-space: nowrap; text-align: right">0.85 ms</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap; text-align: right">71.62</td>
    <td style="white-space: nowrap; text-align: right">13.96 ms</td>
    <td style="white-space: nowrap; text-align: right">±2.42%</td>
    <td style="white-space: nowrap; text-align: right">13.98 ms</td>
    <td style="white-space: nowrap; text-align: right">15.17 ms</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap; text-align: right">67.95</td>
    <td style="white-space: nowrap; text-align: right">14.72 ms</td>
    <td style="white-space: nowrap; text-align: right">±4.24%</td>
    <td style="white-space: nowrap; text-align: right">14.47 ms</td>
    <td style="white-space: nowrap; text-align: right">16.71 ms</td>
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
    <td style="white-space: nowrap;text-align: right">1378.65</td>
    <td>&nbsp;</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap; text-align: right">71.62</td>
    <td style="white-space: nowrap; text-align: right">19.25x</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap; text-align: right">67.95</td>
    <td style="white-space: nowrap; text-align: right">20.29x</td>
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
    <td style="white-space: nowrap">0.22 MB</td>
<td>&nbsp;</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap">15.76 MB</td>
    <td>70.99x</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap">15.79 MB</td>
    <td>71.13x</td>
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
    <td style="white-space: nowrap">time_zone_info_pst</td>
    <td style="white-space: nowrap; text-align: right">1440.37</td>
    <td style="white-space: nowrap; text-align: right">0.69 ms</td>
    <td style="white-space: nowrap; text-align: right">±3.64%</td>
    <td style="white-space: nowrap; text-align: right">0.69 ms</td>
    <td style="white-space: nowrap; text-align: right">0.78 ms</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap; text-align: right">71.96</td>
    <td style="white-space: nowrap; text-align: right">13.90 ms</td>
    <td style="white-space: nowrap; text-align: right">±2.94%</td>
    <td style="white-space: nowrap; text-align: right">13.69 ms</td>
    <td style="white-space: nowrap; text-align: right">15.31 ms</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap; text-align: right">61.86</td>
    <td style="white-space: nowrap; text-align: right">16.16 ms</td>
    <td style="white-space: nowrap; text-align: right">±3.66%</td>
    <td style="white-space: nowrap; text-align: right">15.95 ms</td>
    <td style="white-space: nowrap; text-align: right">18.19 ms</td>
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
    <td style="white-space: nowrap;text-align: right">1440.37</td>
    <td>&nbsp;</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap; text-align: right">71.96</td>
    <td style="white-space: nowrap; text-align: right">20.02x</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap; text-align: right">61.86</td>
    <td style="white-space: nowrap; text-align: right">23.28x</td>
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
    <td style="white-space: nowrap">0.186 MB</td>
<td>&nbsp;</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap">15.72 MB</td>
    <td>84.39x</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap">15.75 MB</td>
    <td>84.55x</td>
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
    <td style="white-space: nowrap">time_zone_info_pst</td>
    <td style="white-space: nowrap; text-align: right">201.40</td>
    <td style="white-space: nowrap; text-align: right">4.97 ms</td>
    <td style="white-space: nowrap; text-align: right">±3.11%</td>
    <td style="white-space: nowrap; text-align: right">4.90 ms</td>
    <td style="white-space: nowrap; text-align: right">5.65 ms</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap; text-align: right">46.18</td>
    <td style="white-space: nowrap; text-align: right">21.66 ms</td>
    <td style="white-space: nowrap; text-align: right">±3.78%</td>
    <td style="white-space: nowrap; text-align: right">21.55 ms</td>
    <td style="white-space: nowrap; text-align: right">23.76 ms</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap; text-align: right">30.97</td>
    <td style="white-space: nowrap; text-align: right">32.28 ms</td>
    <td style="white-space: nowrap; text-align: right">±5.20%</td>
    <td style="white-space: nowrap; text-align: right">31.99 ms</td>
    <td style="white-space: nowrap; text-align: right">37.45 ms</td>
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
    <td style="white-space: nowrap;text-align: right">201.40</td>
    <td>&nbsp;</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap; text-align: right">46.18</td>
    <td style="white-space: nowrap; text-align: right">4.36x</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap; text-align: right">30.97</td>
    <td style="white-space: nowrap; text-align: right">6.5x</td>
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
    <td style="white-space: nowrap">1.10 MB</td>
<td>&nbsp;</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap">16.17 MB</td>
    <td>14.69x</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap">16.27 MB</td>
    <td>14.79x</td>
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
    <td style="white-space: nowrap">time_zone_info_pst</td>
    <td style="white-space: nowrap; text-align: right">131.32</td>
    <td style="white-space: nowrap; text-align: right">7.61 ms</td>
    <td style="white-space: nowrap; text-align: right">±3.02%</td>
    <td style="white-space: nowrap; text-align: right">7.51 ms</td>
    <td style="white-space: nowrap; text-align: right">8.39 ms</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap; text-align: right">41.75</td>
    <td style="white-space: nowrap; text-align: right">23.95 ms</td>
    <td style="white-space: nowrap; text-align: right">±4.03%</td>
    <td style="white-space: nowrap; text-align: right">23.85 ms</td>
    <td style="white-space: nowrap; text-align: right">26.99 ms</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap; text-align: right">28.83</td>
    <td style="white-space: nowrap; text-align: right">34.69 ms</td>
    <td style="white-space: nowrap; text-align: right">±6.14%</td>
    <td style="white-space: nowrap; text-align: right">34.18 ms</td>
    <td style="white-space: nowrap; text-align: right">42.13 ms</td>
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
    <td style="white-space: nowrap;text-align: right">131.32</td>
    <td>&nbsp;</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap; text-align: right">41.75</td>
    <td style="white-space: nowrap; text-align: right">3.15x</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap; text-align: right">28.83</td>
    <td style="white-space: nowrap; text-align: right">4.56x</td>
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
    <td style="white-space: nowrap">1.74 MB</td>
<td>&nbsp;</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap">16.22 MB</td>
    <td>9.32x</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap">16.26 MB</td>
    <td>9.34x</td>
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
    <td style="white-space: nowrap">time_zone_info_pst</td>
    <td style="white-space: nowrap; text-align: right">1591.60</td>
    <td style="white-space: nowrap; text-align: right">0.63 ms</td>
    <td style="white-space: nowrap; text-align: right">±4.43%</td>
    <td style="white-space: nowrap; text-align: right">0.62 ms</td>
    <td style="white-space: nowrap; text-align: right">0.73 ms</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap; text-align: right">115.85</td>
    <td style="white-space: nowrap; text-align: right">8.63 ms</td>
    <td style="white-space: nowrap; text-align: right">±4.36%</td>
    <td style="white-space: nowrap; text-align: right">8.50 ms</td>
    <td style="white-space: nowrap; text-align: right">9.76 ms</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap; text-align: right">72.91</td>
    <td style="white-space: nowrap; text-align: right">13.72 ms</td>
    <td style="white-space: nowrap; text-align: right">±4.55%</td>
    <td style="white-space: nowrap; text-align: right">13.57 ms</td>
    <td style="white-space: nowrap; text-align: right">15.95 ms</td>
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
    <td style="white-space: nowrap;text-align: right">1591.60</td>
    <td>&nbsp;</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap; text-align: right">115.85</td>
    <td style="white-space: nowrap; text-align: right">13.74x</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap; text-align: right">72.91</td>
    <td style="white-space: nowrap; text-align: right">21.83x</td>
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
    <td style="white-space: nowrap">0.197 MB</td>
<td>&nbsp;</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap">7.42 MB</td>
    <td>37.68x</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap">7.44 MB</td>
    <td>37.76x</td>
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
    <td style="white-space: nowrap">time_zone_info_pst</td>
    <td style="white-space: nowrap; text-align: right">577.11</td>
    <td style="white-space: nowrap; text-align: right">1.73 ms</td>
    <td style="white-space: nowrap; text-align: right">±3.47%</td>
    <td style="white-space: nowrap; text-align: right">1.72 ms</td>
    <td style="white-space: nowrap; text-align: right">1.97 ms</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap; text-align: right">100.55</td>
    <td style="white-space: nowrap; text-align: right">9.95 ms</td>
    <td style="white-space: nowrap; text-align: right">±3.94%</td>
    <td style="white-space: nowrap; text-align: right">9.92 ms</td>
    <td style="white-space: nowrap; text-align: right">11.01 ms</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap; text-align: right">65.75</td>
    <td style="white-space: nowrap; text-align: right">15.21 ms</td>
    <td style="white-space: nowrap; text-align: right">±5.79%</td>
    <td style="white-space: nowrap; text-align: right">14.91 ms</td>
    <td style="white-space: nowrap; text-align: right">18.06 ms</td>
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
    <td style="white-space: nowrap;text-align: right">577.11</td>
    <td>&nbsp;</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap; text-align: right">100.55</td>
    <td style="white-space: nowrap; text-align: right">5.74x</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap; text-align: right">65.75</td>
    <td style="white-space: nowrap; text-align: right">8.78x</td>
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
    <td style="white-space: nowrap">0.39 MB</td>
<td>&nbsp;</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap">7.21 MB</td>
    <td>18.4x</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap">7.24 MB</td>
    <td>18.47x</td>
  </tr>

</table>


<hr/>

