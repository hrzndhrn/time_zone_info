Benchmark: TimeZoneDatabase

This benchmark compares `TimeZoneInfo` with
- [`Tzdata`](https://github.com/lau/tzdata),
- [`Tz`](https://github.com/mathieuprog/tz),
- [`zoneinfo`](https://github.com/smartrent/zoneinfo)

`TimeZoneInfo` is using `DataStore.PersistentTerm` in this benchmark.

For the benchmark, each of them calls the function
`TimeZoneDatabase.time_zone_periods_from_wall_datetime/2`.

It is relatively hard to compare these libs because the performance depends on
the configurations of each lib. Therefore, the values here are a rough guide.


## System

Benchmark suite executing on the following system:

<table style="width: 1%">
  <tr>
    <th style="width: 1%; white-space: nowrap">Operating System</th>
    <td>macOS</td>
  </tr><tr>
    <th style="white-space: nowrap">CPU Information</th>
    <td style="white-space: nowrap">Apple M1</td>
  </tr><tr>
    <th style="white-space: nowrap">Number of Available Cores</th>
    <td style="white-space: nowrap">8</td>
  </tr><tr>
    <th style="white-space: nowrap">Available Memory</th>
    <td style="white-space: nowrap">16 GB</td>
  </tr><tr>
    <th style="white-space: nowrap">Elixir Version</th>
    <td style="white-space: nowrap">1.16.0</td>
  </tr><tr>
    <th style="white-space: nowrap">Erlang Version</th>
    <td style="white-space: nowrap">26.2.1</td>
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



__Input: Europe/Berlin 2024-03-31 02:00:01 (gap)__

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
    <td style="white-space: nowrap; text-align: right">2.48 M</td>
    <td style="white-space: nowrap; text-align: right">0.40 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;6463.39%</td>
    <td style="white-space: nowrap; text-align: right">0.33 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">1.33 &micro;s</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap; text-align: right">2.00 M</td>
    <td style="white-space: nowrap; text-align: right">0.50 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;4875.06%</td>
    <td style="white-space: nowrap; text-align: right">0.42 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">1.29 &micro;s</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">0.0207 M</td>
    <td style="white-space: nowrap; text-align: right">48.40 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;8.27%</td>
    <td style="white-space: nowrap; text-align: right">46.00 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">58.96 &micro;s</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">zoninfo</td>
    <td style="white-space: nowrap; text-align: right">0.00504 M</td>
    <td style="white-space: nowrap; text-align: right">198.51 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;73.75%</td>
    <td style="white-space: nowrap; text-align: right">193.62 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">291.46 &micro;s</td>
  </tr>

</table>


Run Time Comparison

<table style="width: 1%">
  <tr>
    <th>Name</th>
    <th style="text-align: right">IPS</th>
    <th style="text-align: right">Slower</th>
  <tr>
    <td style="white-space: nowrap">time_zone_info</td>
    <td style="white-space: nowrap;text-align: right">2.48 M</td>
    <td>&nbsp;</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap; text-align: right">2.00 M</td>
    <td style="white-space: nowrap; text-align: right">1.24x</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">0.0207 M</td>
    <td style="white-space: nowrap; text-align: right">120.04x</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">zoninfo</td>
    <td style="white-space: nowrap; text-align: right">0.00504 M</td>
    <td style="white-space: nowrap; text-align: right">492.33x</td>
  </tr>

</table>



Memory Usage

<table style="width: 1%">
  <tr>
    <th>Name</th>
    <th style="text-align: right">Average</th>
    <th style="text-align: right">Factor</th>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info</td>
    <td style="white-space: nowrap">0.55 KB</td>
    <td>&nbsp;</td>
  </tr>
    <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap">1.40 KB</td>
    <td>2.56x</td>
  </tr>
    <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap">111.52 KB</td>
    <td>203.91x</td>
  </tr>
    <tr>
    <td style="white-space: nowrap">zoninfo</td>
    <td style="white-space: nowrap">23.57 KB</td>
    <td>43.1x</td>
  </tr>
</table>



__Input: Europe/Berlin 2024-06-01 00:00:00__

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
    <td style="white-space: nowrap; text-align: right">3.75 M</td>
    <td style="white-space: nowrap; text-align: right">0.27 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;8738.47%</td>
    <td style="white-space: nowrap; text-align: right">0.167 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">1.04 &micro;s</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">time_zone_info</td>
    <td style="white-space: nowrap; text-align: right">2.47 M</td>
    <td style="white-space: nowrap; text-align: right">0.41 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;8461.14%</td>
    <td style="white-space: nowrap; text-align: right">0.33 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">0.46 &micro;s</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">0.0607 M</td>
    <td style="white-space: nowrap; text-align: right">16.47 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;33.17%</td>
    <td style="white-space: nowrap; text-align: right">16.33 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">19.17 &micro;s</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">zoninfo</td>
    <td style="white-space: nowrap; text-align: right">0.00552 M</td>
    <td style="white-space: nowrap; text-align: right">181.07 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;18.54%</td>
    <td style="white-space: nowrap; text-align: right">180.87 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">259.99 &micro;s</td>
  </tr>

</table>


Run Time Comparison

<table style="width: 1%">
  <tr>
    <th>Name</th>
    <th style="text-align: right">IPS</th>
    <th style="text-align: right">Slower</th>
  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap;text-align: right">3.75 M</td>
    <td>&nbsp;</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">time_zone_info</td>
    <td style="white-space: nowrap; text-align: right">2.47 M</td>
    <td style="white-space: nowrap; text-align: right">1.52x</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">0.0607 M</td>
    <td style="white-space: nowrap; text-align: right">61.7x</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">zoninfo</td>
    <td style="white-space: nowrap; text-align: right">0.00552 M</td>
    <td style="white-space: nowrap; text-align: right">678.39x</td>
  </tr>

</table>



Memory Usage

<table style="width: 1%">
  <tr>
    <th>Name</th>
    <th style="text-align: right">Average</th>
    <th style="text-align: right">Factor</th>
  </tr>
  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap">0.31 KB</td>
    <td>&nbsp;</td>
  </tr>
    <tr>
    <td style="white-space: nowrap">time_zone_info</td>
    <td style="white-space: nowrap">0.44 KB</td>
    <td>1.4x</td>
  </tr>
    <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap">2.21 KB</td>
    <td>7.08x</td>
  </tr>
    <tr>
    <td style="white-space: nowrap">zoninfo</td>
    <td style="white-space: nowrap">22.46 KB</td>
    <td>71.88x</td>
  </tr>
</table>



__Input: Europe/Berlin 2024-10-27 02:00:01 (ambiguous)__

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
    <td style="white-space: nowrap; text-align: right">4.90 M</td>
    <td style="white-space: nowrap; text-align: right">0.20 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;19242.38%</td>
    <td style="white-space: nowrap; text-align: right">0.166 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">0.29 &micro;s</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">time_zone_info</td>
    <td style="white-space: nowrap; text-align: right">2.47 M</td>
    <td style="white-space: nowrap; text-align: right">0.41 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;9742.11%</td>
    <td style="white-space: nowrap; text-align: right">0.33 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">0.50 &micro;s</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">0.0589 M</td>
    <td style="white-space: nowrap; text-align: right">16.97 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;26.26%</td>
    <td style="white-space: nowrap; text-align: right">16.79 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">20.08 &micro;s</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">zoninfo</td>
    <td style="white-space: nowrap; text-align: right">0.00571 M</td>
    <td style="white-space: nowrap; text-align: right">175.09 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;18.11%</td>
    <td style="white-space: nowrap; text-align: right">174.58 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">251.00 &micro;s</td>
  </tr>

</table>


Run Time Comparison

<table style="width: 1%">
  <tr>
    <th>Name</th>
    <th style="text-align: right">IPS</th>
    <th style="text-align: right">Slower</th>
  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap;text-align: right">4.90 M</td>
    <td>&nbsp;</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">time_zone_info</td>
    <td style="white-space: nowrap; text-align: right">2.47 M</td>
    <td style="white-space: nowrap; text-align: right">1.99x</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">0.0589 M</td>
    <td style="white-space: nowrap; text-align: right">83.22x</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">zoninfo</td>
    <td style="white-space: nowrap; text-align: right">0.00571 M</td>
    <td style="white-space: nowrap; text-align: right">858.67x</td>
  </tr>

</table>



Memory Usage

<table style="width: 1%">
  <tr>
    <th>Name</th>
    <th style="text-align: right">Average</th>
    <th style="text-align: right">Factor</th>
  </tr>
  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap">0.37 KB</td>
    <td>&nbsp;</td>
  </tr>
    <tr>
    <td style="white-space: nowrap">time_zone_info</td>
    <td style="white-space: nowrap">0.50 KB</td>
    <td>1.36x</td>
  </tr>
    <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap">3.85 KB</td>
    <td>10.49x</td>
  </tr>
    <tr>
    <td style="white-space: nowrap">zoninfo</td>
    <td style="white-space: nowrap">22.54 KB</td>
    <td>61.38x</td>
  </tr>
</table>



__Input: Europe/Berlin 2099-06-01 00:00:00__

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
    <td style="white-space: nowrap; text-align: right">112.72 K</td>
    <td style="white-space: nowrap; text-align: right">8.87 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;125.56%</td>
    <td style="white-space: nowrap; text-align: right">8 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">21.21 &micro;s</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap; text-align: right">85.81 K</td>
    <td style="white-space: nowrap; text-align: right">11.65 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;163.31%</td>
    <td style="white-space: nowrap; text-align: right">11.25 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">15.37 &micro;s</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">zoninfo</td>
    <td style="white-space: nowrap; text-align: right">5.60 K</td>
    <td style="white-space: nowrap; text-align: right">178.44 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;25.65%</td>
    <td style="white-space: nowrap; text-align: right">177.00 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">265.57 &micro;s</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">3.44 K</td>
    <td style="white-space: nowrap; text-align: right">291.08 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;22.76%</td>
    <td style="white-space: nowrap; text-align: right">331.87 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">348.53 &micro;s</td>
  </tr>

</table>


Run Time Comparison

<table style="width: 1%">
  <tr>
    <th>Name</th>
    <th style="text-align: right">IPS</th>
    <th style="text-align: right">Slower</th>
  <tr>
    <td style="white-space: nowrap">time_zone_info</td>
    <td style="white-space: nowrap;text-align: right">112.72 K</td>
    <td>&nbsp;</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap; text-align: right">85.81 K</td>
    <td style="white-space: nowrap; text-align: right">1.31x</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">zoninfo</td>
    <td style="white-space: nowrap; text-align: right">5.60 K</td>
    <td style="white-space: nowrap; text-align: right">20.11x</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">3.44 K</td>
    <td style="white-space: nowrap; text-align: right">32.81x</td>
  </tr>

</table>



Memory Usage

<table style="width: 1%">
  <tr>
    <th>Name</th>
    <th style="text-align: right">Average</th>
    <th style="text-align: right">Factor</th>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info</td>
    <td style="white-space: nowrap">16.13 KB</td>
    <td>&nbsp;</td>
  </tr>
    <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap">19.45 KB</td>
    <td>1.21x</td>
  </tr>
    <tr>
    <td style="white-space: nowrap">zoninfo</td>
    <td style="white-space: nowrap">22.46 KB</td>
    <td>1.39x</td>
  </tr>
    <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap">10.19 KB</td>
    <td>0.63x</td>
  </tr>
</table>



__Input: Europe/Paris 1950-06-27 22:34:00__

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
    <td style="white-space: nowrap; text-align: right">1.75 M</td>
    <td style="white-space: nowrap; text-align: right">0.57 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;5038.12%</td>
    <td style="white-space: nowrap; text-align: right">0.50 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">0.67 &micro;s</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap; text-align: right">1.60 M</td>
    <td style="white-space: nowrap; text-align: right">0.63 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;4520.56%</td>
    <td style="white-space: nowrap; text-align: right">0.58 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">0.75 &micro;s</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">0.0702 M</td>
    <td style="white-space: nowrap; text-align: right">14.25 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;39.90%</td>
    <td style="white-space: nowrap; text-align: right">14.17 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">15.25 &micro;s</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">zoninfo</td>
    <td style="white-space: nowrap; text-align: right">0.00536 M</td>
    <td style="white-space: nowrap; text-align: right">186.73 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;17.97%</td>
    <td style="white-space: nowrap; text-align: right">185.79 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">266.45 &micro;s</td>
  </tr>

</table>


Run Time Comparison

<table style="width: 1%">
  <tr>
    <th>Name</th>
    <th style="text-align: right">IPS</th>
    <th style="text-align: right">Slower</th>
  <tr>
    <td style="white-space: nowrap">time_zone_info</td>
    <td style="white-space: nowrap;text-align: right">1.75 M</td>
    <td>&nbsp;</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap; text-align: right">1.60 M</td>
    <td style="white-space: nowrap; text-align: right">1.09x</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">0.0702 M</td>
    <td style="white-space: nowrap; text-align: right">24.89x</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">zoninfo</td>
    <td style="white-space: nowrap; text-align: right">0.00536 M</td>
    <td style="white-space: nowrap; text-align: right">326.1x</td>
  </tr>

</table>



Memory Usage

<table style="width: 1%">
  <tr>
    <th>Name</th>
    <th style="text-align: right">Average</th>
    <th style="text-align: right">Factor</th>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info</td>
    <td style="white-space: nowrap">0.44 KB</td>
    <td>&nbsp;</td>
  </tr>
    <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap">0.31 KB</td>
    <td>0.71x</td>
  </tr>
    <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap">2.21 KB</td>
    <td>5.05x</td>
  </tr>
    <tr>
    <td style="white-space: nowrap">zoninfo</td>
    <td style="white-space: nowrap">30.37 KB</td>
    <td>69.41x</td>
  </tr>
</table>