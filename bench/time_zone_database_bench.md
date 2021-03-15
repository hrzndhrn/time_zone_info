
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
    <td style="white-space: nowrap; text-align: right">1.44 K</td>
    <td style="white-space: nowrap; text-align: right">0.69 ms</td>
    <td style="white-space: nowrap; text-align: right">±44.96%</td>
    <td style="white-space: nowrap; text-align: right">0.66 ms</td>
    <td style="white-space: nowrap; text-align: right">1.34 ms</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">time_zone_info</td>
    <td style="white-space: nowrap; text-align: right">1.30 K</td>
    <td style="white-space: nowrap; text-align: right">0.77 ms</td>
    <td style="white-space: nowrap; text-align: right">±15.37%</td>
    <td style="white-space: nowrap; text-align: right">0.75 ms</td>
    <td style="white-space: nowrap; text-align: right">1.15 ms</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">0.0729 K</td>
    <td style="white-space: nowrap; text-align: right">13.72 ms</td>
    <td style="white-space: nowrap; text-align: right">±4.78%</td>
    <td style="white-space: nowrap; text-align: right">13.56 ms</td>
    <td style="white-space: nowrap; text-align: right">16.77 ms</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">zoneinfo</td>
    <td style="white-space: nowrap; text-align: right">0.0121 K</td>
    <td style="white-space: nowrap; text-align: right">82.82 ms</td>
    <td style="white-space: nowrap; text-align: right">±21.16%</td>
    <td style="white-space: nowrap; text-align: right">79.41 ms</td>
    <td style="white-space: nowrap; text-align: right">201.78 ms</td>
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
    <td style="white-space: nowrap;text-align: right">1.44 K</td>
    <td>&nbsp;</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">time_zone_info</td>
    <td style="white-space: nowrap; text-align: right">1.30 K</td>
    <td style="white-space: nowrap; text-align: right">1.11x</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">0.0729 K</td>
    <td style="white-space: nowrap; text-align: right">19.75x</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">zoneinfo</td>
    <td style="white-space: nowrap; text-align: right">0.0121 K</td>
    <td style="white-space: nowrap; text-align: right">119.2x</td>
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
    <td style="white-space: nowrap; text-align: right">1285.16</td>
    <td style="white-space: nowrap; text-align: right">0.78 ms</td>
    <td style="white-space: nowrap; text-align: right">±10.59%</td>
    <td style="white-space: nowrap; text-align: right">0.76 ms</td>
    <td style="white-space: nowrap; text-align: right">1.08 ms</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap; text-align: right">502.26</td>
    <td style="white-space: nowrap; text-align: right">1.99 ms</td>
    <td style="white-space: nowrap; text-align: right">±15.31%</td>
    <td style="white-space: nowrap; text-align: right">1.94 ms</td>
    <td style="white-space: nowrap; text-align: right">2.76 ms</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">zoneinfo</td>
    <td style="white-space: nowrap; text-align: right">9.86</td>
    <td style="white-space: nowrap; text-align: right">101.38 ms</td>
    <td style="white-space: nowrap; text-align: right">±35.36%</td>
    <td style="white-space: nowrap; text-align: right">89.01 ms</td>
    <td style="white-space: nowrap; text-align: right">299.29 ms</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">9.72</td>
    <td style="white-space: nowrap; text-align: right">102.84 ms</td>
    <td style="white-space: nowrap; text-align: right">±3.52%</td>
    <td style="white-space: nowrap; text-align: right">102.03 ms</td>
    <td style="white-space: nowrap; text-align: right">127.08 ms</td>
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
    <td style="white-space: nowrap;text-align: right">1285.16</td>
    <td>&nbsp;</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap; text-align: right">502.26</td>
    <td style="white-space: nowrap; text-align: right">2.56x</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">zoneinfo</td>
    <td style="white-space: nowrap; text-align: right">9.86</td>
    <td style="white-space: nowrap; text-align: right">130.28x</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">9.72</td>
    <td style="white-space: nowrap; text-align: right">132.17x</td>
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
    <td style="white-space: nowrap; text-align: right">1.43 K</td>
    <td style="white-space: nowrap; text-align: right">0.70 ms</td>
    <td style="white-space: nowrap; text-align: right">±16.05%</td>
    <td style="white-space: nowrap; text-align: right">0.69 ms</td>
    <td style="white-space: nowrap; text-align: right">1.06 ms</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">time_zone_info</td>
    <td style="white-space: nowrap; text-align: right">1.32 K</td>
    <td style="white-space: nowrap; text-align: right">0.76 ms</td>
    <td style="white-space: nowrap; text-align: right">±30.88%</td>
    <td style="white-space: nowrap; text-align: right">0.74 ms</td>
    <td style="white-space: nowrap; text-align: right">1.15 ms</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">0.0872 K</td>
    <td style="white-space: nowrap; text-align: right">11.46 ms</td>
    <td style="white-space: nowrap; text-align: right">±6.49%</td>
    <td style="white-space: nowrap; text-align: right">11.31 ms</td>
    <td style="white-space: nowrap; text-align: right">14.79 ms</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">zoneinfo</td>
    <td style="white-space: nowrap; text-align: right">0.0125 K</td>
    <td style="white-space: nowrap; text-align: right">80.18 ms</td>
    <td style="white-space: nowrap; text-align: right">±12.62%</td>
    <td style="white-space: nowrap; text-align: right">77.24 ms</td>
    <td style="white-space: nowrap; text-align: right">145.79 ms</td>
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
    <td style="white-space: nowrap;text-align: right">1.43 K</td>
    <td>&nbsp;</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">time_zone_info</td>
    <td style="white-space: nowrap; text-align: right">1.32 K</td>
    <td style="white-space: nowrap; text-align: right">1.08x</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">0.0872 K</td>
    <td style="white-space: nowrap; text-align: right">16.34x</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">zoneinfo</td>
    <td style="white-space: nowrap; text-align: right">0.0125 K</td>
    <td style="white-space: nowrap; text-align: right">114.26x</td>
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
    <td style="white-space: nowrap; text-align: right">178.20</td>
    <td style="white-space: nowrap; text-align: right">5.61 ms</td>
    <td style="white-space: nowrap; text-align: right">±9.94%</td>
    <td style="white-space: nowrap; text-align: right">5.47 ms</td>
    <td style="white-space: nowrap; text-align: right">7.55 ms</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap; text-align: right">118.81</td>
    <td style="white-space: nowrap; text-align: right">8.42 ms</td>
    <td style="white-space: nowrap; text-align: right">±6.63%</td>
    <td style="white-space: nowrap; text-align: right">8.31 ms</td>
    <td style="white-space: nowrap; text-align: right">10.99 ms</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">78.52</td>
    <td style="white-space: nowrap; text-align: right">12.74 ms</td>
    <td style="white-space: nowrap; text-align: right">±16.62%</td>
    <td style="white-space: nowrap; text-align: right">12.30 ms</td>
    <td style="white-space: nowrap; text-align: right">21.04 ms</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">zoneinfo</td>
    <td style="white-space: nowrap; text-align: right">11.30</td>
    <td style="white-space: nowrap; text-align: right">88.50 ms</td>
    <td style="white-space: nowrap; text-align: right">±10.22%</td>
    <td style="white-space: nowrap; text-align: right">86.24 ms</td>
    <td style="white-space: nowrap; text-align: right">122.44 ms</td>
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
    <td style="white-space: nowrap;text-align: right">178.20</td>
    <td>&nbsp;</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap; text-align: right">118.81</td>
    <td style="white-space: nowrap; text-align: right">1.5x</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">78.52</td>
    <td style="white-space: nowrap; text-align: right">2.27x</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">zoneinfo</td>
    <td style="white-space: nowrap; text-align: right">11.30</td>
    <td style="white-space: nowrap; text-align: right">15.77x</td>
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
    <td style="white-space: nowrap; text-align: right">119.16</td>
    <td style="white-space: nowrap; text-align: right">8.39 ms</td>
    <td style="white-space: nowrap; text-align: right">±6.95%</td>
    <td style="white-space: nowrap; text-align: right">8.28 ms</td>
    <td style="white-space: nowrap; text-align: right">10.93 ms</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap; text-align: right">79.44</td>
    <td style="white-space: nowrap; text-align: right">12.59 ms</td>
    <td style="white-space: nowrap; text-align: right">±6.15%</td>
    <td style="white-space: nowrap; text-align: right">12.44 ms</td>
    <td style="white-space: nowrap; text-align: right">16.45 ms</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">zoneinfo</td>
    <td style="white-space: nowrap; text-align: right">10.88</td>
    <td style="white-space: nowrap; text-align: right">91.92 ms</td>
    <td style="white-space: nowrap; text-align: right">±11.61%</td>
    <td style="white-space: nowrap; text-align: right">89.37 ms</td>
    <td style="white-space: nowrap; text-align: right">164.38 ms</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">9.24</td>
    <td style="white-space: nowrap; text-align: right">108.18 ms</td>
    <td style="white-space: nowrap; text-align: right">±14.95%</td>
    <td style="white-space: nowrap; text-align: right">102.51 ms</td>
    <td style="white-space: nowrap; text-align: right">177.90 ms</td>
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
    <td style="white-space: nowrap;text-align: right">119.16</td>
    <td>&nbsp;</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap; text-align: right">79.44</td>
    <td style="white-space: nowrap; text-align: right">1.5x</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">zoneinfo</td>
    <td style="white-space: nowrap; text-align: right">10.88</td>
    <td style="white-space: nowrap; text-align: right">10.95x</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">9.24</td>
    <td style="white-space: nowrap; text-align: right">12.89x</td>
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
    <td style="white-space: nowrap; text-align: right">1.91 K</td>
    <td style="white-space: nowrap; text-align: right">0.52 ms</td>
    <td style="white-space: nowrap; text-align: right">±20.33%</td>
    <td style="white-space: nowrap; text-align: right">0.51 ms</td>
    <td style="white-space: nowrap; text-align: right">0.81 ms</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">time_zone_info</td>
    <td style="white-space: nowrap; text-align: right">1.40 K</td>
    <td style="white-space: nowrap; text-align: right">0.72 ms</td>
    <td style="white-space: nowrap; text-align: right">±19.06%</td>
    <td style="white-space: nowrap; text-align: right">0.68 ms</td>
    <td style="white-space: nowrap; text-align: right">1.30 ms</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">0.148 K</td>
    <td style="white-space: nowrap; text-align: right">6.74 ms</td>
    <td style="white-space: nowrap; text-align: right">±8.88%</td>
    <td style="white-space: nowrap; text-align: right">6.63 ms</td>
    <td style="white-space: nowrap; text-align: right">9.42 ms</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">zoneinfo</td>
    <td style="white-space: nowrap; text-align: right">0.0147 K</td>
    <td style="white-space: nowrap; text-align: right">68.08 ms</td>
    <td style="white-space: nowrap; text-align: right">±10.43%</td>
    <td style="white-space: nowrap; text-align: right">66.15 ms</td>
    <td style="white-space: nowrap; text-align: right">103.34 ms</td>
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
    <td style="white-space: nowrap;text-align: right">1.91 K</td>
    <td>&nbsp;</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">time_zone_info</td>
    <td style="white-space: nowrap; text-align: right">1.40 K</td>
    <td style="white-space: nowrap; text-align: right">1.37x</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">0.148 K</td>
    <td style="white-space: nowrap; text-align: right">12.88x</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">zoneinfo</td>
    <td style="white-space: nowrap; text-align: right">0.0147 K</td>
    <td style="white-space: nowrap; text-align: right">130.1x</td>
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
    <td style="white-space: nowrap">2.44 MB</td>
    <td>18.5x</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">zoneinfo</td>
    <td style="white-space: nowrap">4.74 MB</td>
    <td>35.86x</td>
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
    <td style="white-space: nowrap; text-align: right">521.07</td>
    <td style="white-space: nowrap; text-align: right">1.92 ms</td>
    <td style="white-space: nowrap; text-align: right">±12.31%</td>
    <td style="white-space: nowrap; text-align: right">1.87 ms</td>
    <td style="white-space: nowrap; text-align: right">2.79 ms</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap; text-align: right">390.36</td>
    <td style="white-space: nowrap; text-align: right">2.56 ms</td>
    <td style="white-space: nowrap; text-align: right">±9.17%</td>
    <td style="white-space: nowrap; text-align: right">2.52 ms</td>
    <td style="white-space: nowrap; text-align: right">3.34 ms</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">147.57</td>
    <td style="white-space: nowrap; text-align: right">6.78 ms</td>
    <td style="white-space: nowrap; text-align: right">±14.63%</td>
    <td style="white-space: nowrap; text-align: right">6.56 ms</td>
    <td style="white-space: nowrap; text-align: right">10.90 ms</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">zoneinfo</td>
    <td style="white-space: nowrap; text-align: right">14.65</td>
    <td style="white-space: nowrap; text-align: right">68.28 ms</td>
    <td style="white-space: nowrap; text-align: right">±7.13%</td>
    <td style="white-space: nowrap; text-align: right">67.14 ms</td>
    <td style="white-space: nowrap; text-align: right">91.79 ms</td>
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
    <td style="white-space: nowrap;text-align: right">521.07</td>
    <td>&nbsp;</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap; text-align: right">390.36</td>
    <td style="white-space: nowrap; text-align: right">1.33x</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">147.57</td>
    <td style="white-space: nowrap; text-align: right">3.53x</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">zoneinfo</td>
    <td style="white-space: nowrap; text-align: right">14.65</td>
    <td style="white-space: nowrap; text-align: right">35.58x</td>
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

