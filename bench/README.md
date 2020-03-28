# Benchmark: TimeZoneDatabase

This benchmark compares `TimeZoneInfo` with
[`Tzdata`](https://github.com/lau/tzdata) and
[`Tz`](https://github.com/mathieuprog/tz).

The `TimeZoneInfo` will be tested in three different configurations.
Each version uses a different strategy to keep the data available.
- `time_zone_info_pst` is using
  [`:persistent_term`](https://erlang.org/doc/man/persistent_term.html)
- `time_zone_info_ets` is using `:ets`
  [(Erlang Term Storage)](https://erlang.org/doc/man/ets.html)
- `time_zone_info_map` is using a `GenServer` with a `Map` as state. This
  version isn't an available configuration in `TimeZoneInfo`. The
  `GenServer` version is otherwise only used in the tests.

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
- **ok_gap_ambiguous:** **ok**, **gap**, and **ambiguous** together.
- **last_year:** 1000 `(datetime, time_zone)` arguments with random time zone
  and a date time from now to one year in the past. The data is calculated
  once for all test candidates.
- **berlin_gap_2020**: Gaps in the time zone `Europe/Berlin` in 2020.
- **berlin_ambiguous_2020**: Ambiguous date time in the time zone
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
    <td style="white-space: nowrap">time_zone_info_pst</td>
    <td style="white-space: nowrap; text-align: right">190.82</td>
    <td style="white-space: nowrap; text-align: right">5.24 ms</td>
    <td style="white-space: nowrap; text-align: right">±6.35%</td>
    <td style="white-space: nowrap; text-align: right">5.16 ms</td>
    <td style="white-space: nowrap; text-align: right">6.35 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap; text-align: right">117.03</td>
    <td style="white-space: nowrap; text-align: right">8.54 ms</td>
    <td style="white-space: nowrap; text-align: right">±6.62%</td>
    <td style="white-space: nowrap; text-align: right">8.43 ms</td>
    <td style="white-space: nowrap; text-align: right">10.22 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">103.66</td>
    <td style="white-space: nowrap; text-align: right">9.65 ms</td>
    <td style="white-space: nowrap; text-align: right">±5.98%</td>
    <td style="white-space: nowrap; text-align: right">9.55 ms</td>
    <td style="white-space: nowrap; text-align: right">11.49 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap; text-align: right">92.51</td>
    <td style="white-space: nowrap; text-align: right">10.81 ms</td>
    <td style="white-space: nowrap; text-align: right">±8.38%</td>
    <td style="white-space: nowrap; text-align: right">10.74 ms</td>
    <td style="white-space: nowrap; text-align: right">13.24 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap; text-align: right">47.36</td>
    <td style="white-space: nowrap; text-align: right">21.11 ms</td>
    <td style="white-space: nowrap; text-align: right">±3.35%</td>
    <td style="white-space: nowrap; text-align: right">20.98 ms</td>
    <td style="white-space: nowrap; text-align: right">23.47 ms</td>
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
    <td style="white-space: nowrap;text-align: right">190.82</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap; text-align: right">117.03</td>
    <td style="white-space: nowrap; text-align: right">1.63x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">103.66</td>
    <td style="white-space: nowrap; text-align: right">1.84x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap; text-align: right">92.51</td>
    <td style="white-space: nowrap; text-align: right">2.06x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap; text-align: right">47.36</td>
    <td style="white-space: nowrap; text-align: right">4.03x</td>
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
    <td style="white-space: nowrap">1.68 MB</td>
      <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap">4.18 MB</td>
    <td>2.48x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap">1.73 MB</td>
    <td>1.03x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap">4.13 MB</td>
    <td>2.45x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap">6.22 MB</td>
    <td>3.7x</td>
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
    <td style="white-space: nowrap">time_zone_info_pst</td>
    <td style="white-space: nowrap; text-align: right">628.79</td>
    <td style="white-space: nowrap; text-align: right">1.59 ms</td>
    <td style="white-space: nowrap; text-align: right">±8.99%</td>
    <td style="white-space: nowrap; text-align: right">1.54 ms</td>
    <td style="white-space: nowrap; text-align: right">2.14 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap; text-align: right">627.27</td>
    <td style="white-space: nowrap; text-align: right">1.59 ms</td>
    <td style="white-space: nowrap; text-align: right">±9.24%</td>
    <td style="white-space: nowrap; text-align: right">1.54 ms</td>
    <td style="white-space: nowrap; text-align: right">2.19 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap; text-align: right">116.38</td>
    <td style="white-space: nowrap; text-align: right">8.59 ms</td>
    <td style="white-space: nowrap; text-align: right">±9.48%</td>
    <td style="white-space: nowrap; text-align: right">8.42 ms</td>
    <td style="white-space: nowrap; text-align: right">10.99 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap; text-align: right">89.05</td>
    <td style="white-space: nowrap; text-align: right">11.23 ms</td>
    <td style="white-space: nowrap; text-align: right">±4.12%</td>
    <td style="white-space: nowrap; text-align: right">11.13 ms</td>
    <td style="white-space: nowrap; text-align: right">12.87 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">28.90</td>
    <td style="white-space: nowrap; text-align: right">34.60 ms</td>
    <td style="white-space: nowrap; text-align: right">±2.69%</td>
    <td style="white-space: nowrap; text-align: right">34.49 ms</td>
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
    <td style="white-space: nowrap;text-align: right">628.79</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap; text-align: right">627.27</td>
    <td style="white-space: nowrap; text-align: right">1.0x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap; text-align: right">116.38</td>
    <td style="white-space: nowrap; text-align: right">5.4x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap; text-align: right">89.05</td>
    <td style="white-space: nowrap; text-align: right">7.06x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">28.90</td>
    <td style="white-space: nowrap; text-align: right">21.75x</td>
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
    <td style="white-space: nowrap">0.93 MB</td>
      <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap">0.31 MB</td>
    <td>0.33x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap">10.23 MB</td>
    <td>10.99x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap">10.33 MB</td>
    <td>11.1x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap">3.97 MB</td>
    <td>4.26x</td>
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
    <td style="white-space: nowrap; text-align: right">574.69</td>
    <td style="white-space: nowrap; text-align: right">1.74 ms</td>
    <td style="white-space: nowrap; text-align: right">±8.56%</td>
    <td style="white-space: nowrap; text-align: right">1.69 ms</td>
    <td style="white-space: nowrap; text-align: right">2.34 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_pst</td>
    <td style="white-space: nowrap; text-align: right">269.93</td>
    <td style="white-space: nowrap; text-align: right">3.70 ms</td>
    <td style="white-space: nowrap; text-align: right">±6.45%</td>
    <td style="white-space: nowrap; text-align: right">3.64 ms</td>
    <td style="white-space: nowrap; text-align: right">4.53 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap; text-align: right">92.39</td>
    <td style="white-space: nowrap; text-align: right">10.82 ms</td>
    <td style="white-space: nowrap; text-align: right">±4.42%</td>
    <td style="white-space: nowrap; text-align: right">10.74 ms</td>
    <td style="white-space: nowrap; text-align: right">12.42 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap; text-align: right">72.87</td>
    <td style="white-space: nowrap; text-align: right">13.72 ms</td>
    <td style="white-space: nowrap; text-align: right">±4.29%</td>
    <td style="white-space: nowrap; text-align: right">13.62 ms</td>
    <td style="white-space: nowrap; text-align: right">15.66 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">5.77</td>
    <td style="white-space: nowrap; text-align: right">173.45 ms</td>
    <td style="white-space: nowrap; text-align: right">±1.18%</td>
    <td style="white-space: nowrap; text-align: right">173.46 ms</td>
    <td style="white-space: nowrap; text-align: right">179.23 ms</td>
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
    <td style="white-space: nowrap;text-align: right">574.69</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_pst</td>
    <td style="white-space: nowrap; text-align: right">269.93</td>
    <td style="white-space: nowrap; text-align: right">2.13x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap; text-align: right">92.39</td>
    <td style="white-space: nowrap; text-align: right">6.22x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap; text-align: right">72.87</td>
    <td style="white-space: nowrap; text-align: right">7.89x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">5.77</td>
    <td style="white-space: nowrap; text-align: right">99.68x</td>
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
    <td style="white-space: nowrap">0.29 MB</td>
      <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_pst</td>
    <td style="white-space: nowrap">1.95 MB</td>
    <td>6.71x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap">11.51 MB</td>
    <td>39.71x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap">11.62 MB</td>
    <td>40.07x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap">135.87 MB</td>
    <td>468.67x</td>
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
    <td style="white-space: nowrap">time_zone_info_pst</td>
    <td style="white-space: nowrap; text-align: right">125.44</td>
    <td style="white-space: nowrap; text-align: right">7.97 ms</td>
    <td style="white-space: nowrap; text-align: right">±5.01%</td>
    <td style="white-space: nowrap; text-align: right">7.90 ms</td>
    <td style="white-space: nowrap; text-align: right">9.32 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap; text-align: right">86.06</td>
    <td style="white-space: nowrap; text-align: right">11.62 ms</td>
    <td style="white-space: nowrap; text-align: right">±6.31%</td>
    <td style="white-space: nowrap; text-align: right">11.49 ms</td>
    <td style="white-space: nowrap; text-align: right">14.16 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap; text-align: right">69.41</td>
    <td style="white-space: nowrap; text-align: right">14.41 ms</td>
    <td style="white-space: nowrap; text-align: right">±5.95%</td>
    <td style="white-space: nowrap; text-align: right">14.29 ms</td>
    <td style="white-space: nowrap; text-align: right">16.93 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap; text-align: right">34.44</td>
    <td style="white-space: nowrap; text-align: right">29.04 ms</td>
    <td style="white-space: nowrap; text-align: right">±3.65%</td>
    <td style="white-space: nowrap; text-align: right">28.86 ms</td>
    <td style="white-space: nowrap; text-align: right">32.72 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">17.82</td>
    <td style="white-space: nowrap; text-align: right">56.11 ms</td>
    <td style="white-space: nowrap; text-align: right">±4.23%</td>
    <td style="white-space: nowrap; text-align: right">55.56 ms</td>
    <td style="white-space: nowrap; text-align: right">66.60 ms</td>
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
    <td style="white-space: nowrap;text-align: right">125.44</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap; text-align: right">86.06</td>
    <td style="white-space: nowrap; text-align: right">1.46x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap; text-align: right">69.41</td>
    <td style="white-space: nowrap; text-align: right">1.81x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap; text-align: right">34.44</td>
    <td style="white-space: nowrap; text-align: right">3.64x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">17.82</td>
    <td style="white-space: nowrap; text-align: right">7.04x</td>
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
    <td style="white-space: nowrap">2.38 MB</td>
      <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap">4.54 MB</td>
    <td>1.91x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap">4.64 MB</td>
    <td>1.95x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap">8.34 MB</td>
    <td>3.51x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap">41.31 MB</td>
    <td>17.38x</td>
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
    <td style="white-space: nowrap">time_zone_info_pst</td>
    <td style="white-space: nowrap; text-align: right">681.70</td>
    <td style="white-space: nowrap; text-align: right">1.47 ms</td>
    <td style="white-space: nowrap; text-align: right">±12.07%</td>
    <td style="white-space: nowrap; text-align: right">1.40 ms</td>
    <td style="white-space: nowrap; text-align: right">2.25 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap; text-align: right">617.40</td>
    <td style="white-space: nowrap; text-align: right">1.62 ms</td>
    <td style="white-space: nowrap; text-align: right">±14.15%</td>
    <td style="white-space: nowrap; text-align: right">1.53 ms</td>
    <td style="white-space: nowrap; text-align: right">2.64 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap; text-align: right">171.35</td>
    <td style="white-space: nowrap; text-align: right">5.84 ms</td>
    <td style="white-space: nowrap; text-align: right">±9.32%</td>
    <td style="white-space: nowrap; text-align: right">5.70 ms</td>
    <td style="white-space: nowrap; text-align: right">7.64 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap; text-align: right">116.11</td>
    <td style="white-space: nowrap; text-align: right">8.61 ms</td>
    <td style="white-space: nowrap; text-align: right">±10.80%</td>
    <td style="white-space: nowrap; text-align: right">8.52 ms</td>
    <td style="white-space: nowrap; text-align: right">11.39 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">66.23</td>
    <td style="white-space: nowrap; text-align: right">15.10 ms</td>
    <td style="white-space: nowrap; text-align: right">±4.39%</td>
    <td style="white-space: nowrap; text-align: right">15.03 ms</td>
    <td style="white-space: nowrap; text-align: right">17.02 ms</td>
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
    <td style="white-space: nowrap;text-align: right">681.70</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap; text-align: right">617.40</td>
    <td style="white-space: nowrap; text-align: right">1.1x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap; text-align: right">171.35</td>
    <td style="white-space: nowrap; text-align: right">3.98x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap; text-align: right">116.11</td>
    <td style="white-space: nowrap; text-align: right">5.87x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">66.23</td>
    <td style="white-space: nowrap; text-align: right">10.29x</td>
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
    <td style="white-space: nowrap">0.76 MB</td>
      <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap">0.30 MB</td>
    <td>0.4x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap">5.20 MB</td>
    <td>6.82x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap">5.26 MB</td>
    <td>6.9x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap">4.33 MB</td>
    <td>5.67x</td>
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
    <td style="white-space: nowrap">time_zone_info_pst</td>
    <td style="white-space: nowrap; text-align: right">547.14</td>
    <td style="white-space: nowrap; text-align: right">1.83 ms</td>
    <td style="white-space: nowrap; text-align: right">±10.88%</td>
    <td style="white-space: nowrap; text-align: right">1.75 ms</td>
    <td style="white-space: nowrap; text-align: right">2.65 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap; text-align: right">291.92</td>
    <td style="white-space: nowrap; text-align: right">3.43 ms</td>
    <td style="white-space: nowrap; text-align: right">±13.10%</td>
    <td style="white-space: nowrap; text-align: right">3.27 ms</td>
    <td style="white-space: nowrap; text-align: right">5.12 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap; text-align: right">217.95</td>
    <td style="white-space: nowrap; text-align: right">4.59 ms</td>
    <td style="white-space: nowrap; text-align: right">±13.54%</td>
    <td style="white-space: nowrap; text-align: right">4.39 ms</td>
    <td style="white-space: nowrap; text-align: right">6.45 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">196.68</td>
    <td style="white-space: nowrap; text-align: right">5.08 ms</td>
    <td style="white-space: nowrap; text-align: right">±9.12%</td>
    <td style="white-space: nowrap; text-align: right">4.94 ms</td>
    <td style="white-space: nowrap; text-align: right">6.40 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap; text-align: right">188.56</td>
    <td style="white-space: nowrap; text-align: right">5.30 ms</td>
    <td style="white-space: nowrap; text-align: right">±7.40%</td>
    <td style="white-space: nowrap; text-align: right">5.17 ms</td>
    <td style="white-space: nowrap; text-align: right">6.56 ms</td>
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
    <td style="white-space: nowrap;text-align: right">547.14</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap; text-align: right">291.92</td>
    <td style="white-space: nowrap; text-align: right">1.87x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap; text-align: right">217.95</td>
    <td style="white-space: nowrap; text-align: right">2.51x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">196.68</td>
    <td style="white-space: nowrap; text-align: right">2.78x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap; text-align: right">188.56</td>
    <td style="white-space: nowrap; text-align: right">2.9x</td>
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
    <td style="white-space: nowrap">0.72 MB</td>
      <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap">1.92 MB</td>
    <td>2.66x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap">1.92 MB</td>
    <td>2.67x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap">1.29 MB</td>
    <td>1.79x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap">1.46 MB</td>
    <td>2.03x</td>
  </tr>
</table>
<hr/>

__Input: ok_gap_ambiguous__

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
    <td style="white-space: nowrap; text-align: right">65.92</td>
    <td style="white-space: nowrap; text-align: right">15.17 ms</td>
    <td style="white-space: nowrap; text-align: right">±3.79%</td>
    <td style="white-space: nowrap; text-align: right">15.10 ms</td>
    <td style="white-space: nowrap; text-align: right">17.23 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap; text-align: right">42.97</td>
    <td style="white-space: nowrap; text-align: right">23.27 ms</td>
    <td style="white-space: nowrap; text-align: right">±5.65%</td>
    <td style="white-space: nowrap; text-align: right">23.03 ms</td>
    <td style="white-space: nowrap; text-align: right">28.09 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap; text-align: right">33.70</td>
    <td style="white-space: nowrap; text-align: right">29.68 ms</td>
    <td style="white-space: nowrap; text-align: right">±5.13%</td>
    <td style="white-space: nowrap; text-align: right">29.56 ms</td>
    <td style="white-space: nowrap; text-align: right">34.81 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap; text-align: right">18.04</td>
    <td style="white-space: nowrap; text-align: right">55.42 ms</td>
    <td style="white-space: nowrap; text-align: right">±2.88%</td>
    <td style="white-space: nowrap; text-align: right">55.11 ms</td>
    <td style="white-space: nowrap; text-align: right">61.92 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">14.51</td>
    <td style="white-space: nowrap; text-align: right">68.94 ms</td>
    <td style="white-space: nowrap; text-align: right">±2.28%</td>
    <td style="white-space: nowrap; text-align: right">68.76 ms</td>
    <td style="white-space: nowrap; text-align: right">73.54 ms</td>
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
    <td style="white-space: nowrap;text-align: right">65.92</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap; text-align: right">42.97</td>
    <td style="white-space: nowrap; text-align: right">1.53x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap; text-align: right">33.70</td>
    <td style="white-space: nowrap; text-align: right">1.96x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap; text-align: right">18.04</td>
    <td style="white-space: nowrap; text-align: right">3.65x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">14.51</td>
    <td style="white-space: nowrap; text-align: right">4.54x</td>
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
    <td style="white-space: nowrap">4.78 MB</td>
      <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap">10.62 MB</td>
    <td>2.22x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap">10.69 MB</td>
    <td>2.24x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap">16.03 MB</td>
    <td>3.35x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap">44.74 MB</td>
    <td>9.36x</td>
  </tr>
</table>
<hr/>
