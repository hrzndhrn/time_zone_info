
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




__Input: Europe/Berlin 2020-03-29 02:00:01 (gap)__

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
    <td style="white-space: nowrap; text-align: right">423.45 K</td>
    <td style="white-space: nowrap; text-align: right">2.36 μs</td>
    <td style="white-space: nowrap; text-align: right">±1098.49%</td>
    <td style="white-space: nowrap; text-align: right">1.97 μs</td>
    <td style="white-space: nowrap; text-align: right">2.97 μs</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap; text-align: right">178.12 K</td>
    <td style="white-space: nowrap; text-align: right">5.61 μs</td>
    <td style="white-space: nowrap; text-align: right">±385.68%</td>
    <td style="white-space: nowrap; text-align: right">4.97 μs</td>
    <td style="white-space: nowrap; text-align: right">8.97 μs</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">zoneinfo</td>
    <td style="white-space: nowrap; text-align: right">4.69 K</td>
    <td style="white-space: nowrap; text-align: right">213.28 μs</td>
    <td style="white-space: nowrap; text-align: right">±20.15%</td>
    <td style="white-space: nowrap; text-align: right">197.97 μs</td>
    <td style="white-space: nowrap; text-align: right">359.97 μs</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">3.68 K</td>
    <td style="white-space: nowrap; text-align: right">271.79 μs</td>
    <td style="white-space: nowrap; text-align: right">±7.76%</td>
    <td style="white-space: nowrap; text-align: right">266.97 μs</td>
    <td style="white-space: nowrap; text-align: right">362.97 μs</td>
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
    <td style="white-space: nowrap;text-align: right">423.45 K</td>
    <td>&nbsp;</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap; text-align: right">178.12 K</td>
    <td style="white-space: nowrap; text-align: right">2.38x</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">zoneinfo</td>
    <td style="white-space: nowrap; text-align: right">4.69 K</td>
    <td style="white-space: nowrap; text-align: right">90.31x</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">3.68 K</td>
    <td style="white-space: nowrap; text-align: right">115.09x</td>
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
    <td style="white-space: nowrap">0.68 KB</td>
<td>&nbsp;</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap">1.84 KB</td>
    <td>2.7x</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">zoneinfo</td>
    <td style="white-space: nowrap">23.81 KB</td>
    <td>35.03x</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap">117.18 KB</td>
    <td>172.4x</td>
  </tr>

</table>


<hr/>


__Input: Europe/Berlin 2020-06-01 00:00:00__

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
    <td style="white-space: nowrap; text-align: right">477.25 K</td>
    <td style="white-space: nowrap; text-align: right">2.10 μs</td>
    <td style="white-space: nowrap; text-align: right">±1425.39%</td>
    <td style="white-space: nowrap; text-align: right">1.97 μs</td>
    <td style="white-space: nowrap; text-align: right">2.97 μs</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">time_zone_info</td>
    <td style="white-space: nowrap; text-align: right">436.77 K</td>
    <td style="white-space: nowrap; text-align: right">2.29 μs</td>
    <td style="white-space: nowrap; text-align: right">±1522.07%</td>
    <td style="white-space: nowrap; text-align: right">1.97 μs</td>
    <td style="white-space: nowrap; text-align: right">2.97 μs</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">31.53 K</td>
    <td style="white-space: nowrap; text-align: right">31.72 μs</td>
    <td style="white-space: nowrap; text-align: right">±21.56%</td>
    <td style="white-space: nowrap; text-align: right">30.97 μs</td>
    <td style="white-space: nowrap; text-align: right">47.97 μs</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">zoneinfo</td>
    <td style="white-space: nowrap; text-align: right">4.78 K</td>
    <td style="white-space: nowrap; text-align: right">209.00 μs</td>
    <td style="white-space: nowrap; text-align: right">±22.53%</td>
    <td style="white-space: nowrap; text-align: right">191.97 μs</td>
    <td style="white-space: nowrap; text-align: right">370.97 μs</td>
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
    <td style="white-space: nowrap;text-align: right">477.25 K</td>
    <td>&nbsp;</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">time_zone_info</td>
    <td style="white-space: nowrap; text-align: right">436.77 K</td>
    <td style="white-space: nowrap; text-align: right">1.09x</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">31.53 K</td>
    <td style="white-space: nowrap; text-align: right">15.14x</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">zoneinfo</td>
    <td style="white-space: nowrap; text-align: right">4.78 K</td>
    <td style="white-space: nowrap; text-align: right">99.75x</td>
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
    <td style="white-space: nowrap">0.39 KB</td>
<td>&nbsp;</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">time_zone_info</td>
    <td style="white-space: nowrap">0.57 KB</td>
    <td>1.46x</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap">2.72 KB</td>
    <td>6.96x</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">zoneinfo</td>
    <td style="white-space: nowrap">22.34 KB</td>
    <td>57.2x</td>
  </tr>

</table>


<hr/>


__Input: Europe/Berlin 2020-10-25 02:00:01 (ambiguous)__

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
    <td style="white-space: nowrap; text-align: right">491.28 K</td>
    <td style="white-space: nowrap; text-align: right">2.04 μs</td>
    <td style="white-space: nowrap; text-align: right">±1412.73%</td>
    <td style="white-space: nowrap; text-align: right">1.97 μs</td>
    <td style="white-space: nowrap; text-align: right">2.97 μs</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">time_zone_info</td>
    <td style="white-space: nowrap; text-align: right">439.35 K</td>
    <td style="white-space: nowrap; text-align: right">2.28 μs</td>
    <td style="white-space: nowrap; text-align: right">±1526.12%</td>
    <td style="white-space: nowrap; text-align: right">1.97 μs</td>
    <td style="white-space: nowrap; text-align: right">2.97 μs</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">26.13 K</td>
    <td style="white-space: nowrap; text-align: right">38.28 μs</td>
    <td style="white-space: nowrap; text-align: right">±114.08%</td>
    <td style="white-space: nowrap; text-align: right">36.97 μs</td>
    <td style="white-space: nowrap; text-align: right">56.97 μs</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">zoneinfo</td>
    <td style="white-space: nowrap; text-align: right">4.64 K</td>
    <td style="white-space: nowrap; text-align: right">215.39 μs</td>
    <td style="white-space: nowrap; text-align: right">±24.77%</td>
    <td style="white-space: nowrap; text-align: right">195.97 μs</td>
    <td style="white-space: nowrap; text-align: right">410.97 μs</td>
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
    <td style="white-space: nowrap;text-align: right">491.28 K</td>
    <td>&nbsp;</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">time_zone_info</td>
    <td style="white-space: nowrap; text-align: right">439.35 K</td>
    <td style="white-space: nowrap; text-align: right">1.12x</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">26.13 K</td>
    <td style="white-space: nowrap; text-align: right">18.8x</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">zoneinfo</td>
    <td style="white-space: nowrap; text-align: right">4.64 K</td>
    <td style="white-space: nowrap; text-align: right">105.81x</td>
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
    <td style="white-space: nowrap">0.45 KB</td>
<td>&nbsp;</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">time_zone_info</td>
    <td style="white-space: nowrap">0.63 KB</td>
    <td>1.42x</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap">4.94 KB</td>
    <td>11.09x</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">zoneinfo</td>
    <td style="white-space: nowrap">22.42 KB</td>
    <td>50.35x</td>
  </tr>

</table>


<hr/>


__Input: Europe/Paris 1944-08-26 13:00:00__

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
    <td style="white-space: nowrap; text-align: right">256.51 K</td>
    <td style="white-space: nowrap; text-align: right">3.90 μs</td>
    <td style="white-space: nowrap; text-align: right">±494.00%</td>
    <td style="white-space: nowrap; text-align: right">3.97 μs</td>
    <td style="white-space: nowrap; text-align: right">5.97 μs</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap; text-align: right">122.25 K</td>
    <td style="white-space: nowrap; text-align: right">8.18 μs</td>
    <td style="white-space: nowrap; text-align: right">±231.95%</td>
    <td style="white-space: nowrap; text-align: right">7.97 μs</td>
    <td style="white-space: nowrap; text-align: right">11.97 μs</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">29.77 K</td>
    <td style="white-space: nowrap; text-align: right">33.59 μs</td>
    <td style="white-space: nowrap; text-align: right">±23.34%</td>
    <td style="white-space: nowrap; text-align: right">32.97 μs</td>
    <td style="white-space: nowrap; text-align: right">50.97 μs</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">zoneinfo</td>
    <td style="white-space: nowrap; text-align: right">3.97 K</td>
    <td style="white-space: nowrap; text-align: right">251.69 μs</td>
    <td style="white-space: nowrap; text-align: right">±18.59%</td>
    <td style="white-space: nowrap; text-align: right">232.97 μs</td>
    <td style="white-space: nowrap; text-align: right">423.97 μs</td>
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
    <td style="white-space: nowrap;text-align: right">256.51 K</td>
    <td>&nbsp;</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap; text-align: right">122.25 K</td>
    <td style="white-space: nowrap; text-align: right">2.1x</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">29.77 K</td>
    <td style="white-space: nowrap; text-align: right">8.62x</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">zoneinfo</td>
    <td style="white-space: nowrap; text-align: right">3.97 K</td>
    <td style="white-space: nowrap; text-align: right">64.56x</td>
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
    <td style="white-space: nowrap">0.57 KB</td>
<td>&nbsp;</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap">0.39 KB</td>
    <td>0.68x</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap">4.89 KB</td>
    <td>8.58x</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">zoneinfo</td>
    <td style="white-space: nowrap">30.26 KB</td>
    <td>53.05x</td>
  </tr>

</table>


<hr/>

