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
    <td style="white-space: nowrap">1.20.4</td>
  </tr><tr>
    <th style="white-space: nowrap">Erlang Version</th>
    <td style="white-space: nowrap">29.1.1</td>
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
    <th style="text-align: right">Deviation</th>
    <th style="text-align: right">Median</th>
    <th style="text-align: right">99th&nbsp;%</th>
  </tr>

  <tr>
    <td style="white-space: nowrap">time_zone_info</td>
    <td style="white-space: nowrap; text-align: right">3.23 M</td>
    <td style="white-space: nowrap; text-align: right">0.31 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;2849.19%</td>
    <td style="white-space: nowrap; text-align: right">0.25 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">0.42 &micro;s</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap; text-align: right">1.55 M</td>
    <td style="white-space: nowrap; text-align: right">0.64 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;10189.39%</td>
    <td style="white-space: nowrap; text-align: right">0.38 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">1.21 &micro;s</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">0.0171 M</td>
    <td style="white-space: nowrap; text-align: right">58.64 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;459.71%</td>
    <td style="white-space: nowrap; text-align: right">52.58 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">136.50 &micro;s</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">zoninfo</td>
    <td style="white-space: nowrap; text-align: right">0.0119 M</td>
    <td style="white-space: nowrap; text-align: right">84.22 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;456.28%</td>
    <td style="white-space: nowrap; text-align: right">69.29 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">286.26 &micro;s</td>
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
    <td style="white-space: nowrap;text-align: right">3.23 M</td>
    <td>&nbsp;</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap; text-align: right">1.55 M</td>
    <td style="white-space: nowrap; text-align: right">2.08x</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">0.0171 M</td>
    <td style="white-space: nowrap; text-align: right">189.26x</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">zoninfo</td>
    <td style="white-space: nowrap; text-align: right">0.0119 M</td>
    <td style="white-space: nowrap; text-align: right">271.82x</td>
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
    <td style="white-space: nowrap">0.40 KB</td>
    <td>&nbsp;</td>
  </tr>
    <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap">0.93 KB</td>
    <td>2.33x</td>
  </tr>
    <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap">112.84 KB</td>
    <td>283.2x</td>
  </tr>
    <tr>
    <td style="white-space: nowrap">zoninfo</td>
    <td style="white-space: nowrap">22.48 KB</td>
    <td>56.43x</td>
  </tr>
</table>



__Input: Europe/Berlin 2024-06-01 00:00:00__

Run Time

<table style="width: 1%">
  <tr>
    <th>Name</th>
    <th style="text-align: right">IPS</th>
    <th style="text-align: right">Average</th>
    <th style="text-align: right">Deviation</th>
    <th style="text-align: right">Median</th>
    <th style="text-align: right">99th&nbsp;%</th>
  </tr>

  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap; text-align: right">4.74 M</td>
    <td style="white-space: nowrap; text-align: right">0.21 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;2917.42%</td>
    <td style="white-space: nowrap; text-align: right">0.167 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">0.33 &micro;s</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">time_zone_info</td>
    <td style="white-space: nowrap; text-align: right">3.47 M</td>
    <td style="white-space: nowrap; text-align: right">0.29 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;2436.32%</td>
    <td style="white-space: nowrap; text-align: right">0.25 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">0.42 &micro;s</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">0.0548 M</td>
    <td style="white-space: nowrap; text-align: right">18.24 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;1415.57%</td>
    <td style="white-space: nowrap; text-align: right">16.62 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">37.29 &micro;s</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">zoninfo</td>
    <td style="white-space: nowrap; text-align: right">0.0110 M</td>
    <td style="white-space: nowrap; text-align: right">90.99 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;407.95%</td>
    <td style="white-space: nowrap; text-align: right">69.92 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">337.02 &micro;s</td>
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
    <td style="white-space: nowrap;text-align: right">4.74 M</td>
    <td>&nbsp;</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">time_zone_info</td>
    <td style="white-space: nowrap; text-align: right">3.47 M</td>
    <td style="white-space: nowrap; text-align: right">1.37x</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">0.0548 M</td>
    <td style="white-space: nowrap; text-align: right">86.54x</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">zoninfo</td>
    <td style="white-space: nowrap; text-align: right">0.0110 M</td>
    <td style="white-space: nowrap; text-align: right">431.63x</td>
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
    <td style="white-space: nowrap">0.22 KB</td>
    <td>&nbsp;</td>
  </tr>
    <tr>
    <td style="white-space: nowrap">time_zone_info</td>
    <td style="white-space: nowrap">0.29 KB</td>
    <td>1.32x</td>
  </tr>
    <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap">1.70 KB</td>
    <td>7.75x</td>
  </tr>
    <tr>
    <td style="white-space: nowrap">zoninfo</td>
    <td style="white-space: nowrap">21.75 KB</td>
    <td>99.42x</td>
  </tr>
</table>



__Input: Europe/Berlin 2024-10-27 02:00:01 (ambiguous)__

Run Time

<table style="width: 1%">
  <tr>
    <th>Name</th>
    <th style="text-align: right">IPS</th>
    <th style="text-align: right">Average</th>
    <th style="text-align: right">Deviation</th>
    <th style="text-align: right">Median</th>
    <th style="text-align: right">99th&nbsp;%</th>
  </tr>

  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap; text-align: right">4.94 M</td>
    <td style="white-space: nowrap; text-align: right">0.20 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;2967.19%</td>
    <td style="white-space: nowrap; text-align: right">0.167 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">0.29 &micro;s</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">time_zone_info</td>
    <td style="white-space: nowrap; text-align: right">3.40 M</td>
    <td style="white-space: nowrap; text-align: right">0.29 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;3457.07%</td>
    <td style="white-space: nowrap; text-align: right">0.25 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">0.38 &micro;s</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">0.0529 M</td>
    <td style="white-space: nowrap; text-align: right">18.91 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;860.13%</td>
    <td style="white-space: nowrap; text-align: right">17.04 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">43.58 &micro;s</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">zoninfo</td>
    <td style="white-space: nowrap; text-align: right">0.0120 M</td>
    <td style="white-space: nowrap; text-align: right">83.63 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;416.44%</td>
    <td style="white-space: nowrap; text-align: right">68.66 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">289.37 &micro;s</td>
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
    <td style="white-space: nowrap;text-align: right">4.94 M</td>
    <td>&nbsp;</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">time_zone_info</td>
    <td style="white-space: nowrap; text-align: right">3.40 M</td>
    <td style="white-space: nowrap; text-align: right">1.45x</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">0.0529 M</td>
    <td style="white-space: nowrap; text-align: right">93.42x</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">zoninfo</td>
    <td style="white-space: nowrap; text-align: right">0.0120 M</td>
    <td style="white-space: nowrap; text-align: right">413.1x</td>
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
    <td style="white-space: nowrap">0.27 KB</td>
    <td>&nbsp;</td>
  </tr>
    <tr>
    <td style="white-space: nowrap">time_zone_info</td>
    <td style="white-space: nowrap">0.35 KB</td>
    <td>1.29x</td>
  </tr>
    <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap">2.94 KB</td>
    <td>10.74x</td>
  </tr>
    <tr>
    <td style="white-space: nowrap">zoninfo</td>
    <td style="white-space: nowrap">21.83 KB</td>
    <td>79.82x</td>
  </tr>
</table>



__Input: Europe/Berlin 2099-06-01 00:00:00__

Run Time

<table style="width: 1%">
  <tr>
    <th>Name</th>
    <th style="text-align: right">IPS</th>
    <th style="text-align: right">Average</th>
    <th style="text-align: right">Deviation</th>
    <th style="text-align: right">Median</th>
    <th style="text-align: right">99th&nbsp;%</th>
  </tr>

  <tr>
    <td style="white-space: nowrap">time_zone_info</td>
    <td style="white-space: nowrap; text-align: right">143.56 K</td>
    <td style="white-space: nowrap; text-align: right">6.97 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;1451.20%</td>
    <td style="white-space: nowrap; text-align: right">6.25 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">17.62 &micro;s</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap; text-align: right">38.97 K</td>
    <td style="white-space: nowrap; text-align: right">25.66 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;558.96%</td>
    <td style="white-space: nowrap; text-align: right">21.71 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">67.00 &micro;s</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">zoninfo</td>
    <td style="white-space: nowrap; text-align: right">11.53 K</td>
    <td style="white-space: nowrap; text-align: right">86.69 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;408.52%</td>
    <td style="white-space: nowrap; text-align: right">68.71 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">310.46 &micro;s</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">2.75 K</td>
    <td style="white-space: nowrap; text-align: right">364.02 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;221.50%</td>
    <td style="white-space: nowrap; text-align: right">380.66 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">1096.13 &micro;s</td>
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
    <td style="white-space: nowrap;text-align: right">143.56 K</td>
    <td>&nbsp;</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap; text-align: right">38.97 K</td>
    <td style="white-space: nowrap; text-align: right">3.68x</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">zoninfo</td>
    <td style="white-space: nowrap; text-align: right">11.53 K</td>
    <td style="white-space: nowrap; text-align: right">12.45x</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">2.75 K</td>
    <td style="white-space: nowrap; text-align: right">52.26x</td>
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
    <td style="white-space: nowrap">12.95 KB</td>
    <td>&nbsp;</td>
  </tr>
    <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap">31.05 KB</td>
    <td>2.4x</td>
  </tr>
    <tr>
    <td style="white-space: nowrap">zoninfo</td>
    <td style="white-space: nowrap">21.75 KB</td>
    <td>1.68x</td>
  </tr>
    <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap">10.74 KB</td>
    <td>0.83x</td>
  </tr>
</table>



__Input: Europe/Paris 1950-06-27 22:34:00__

Run Time

<table style="width: 1%">
  <tr>
    <th>Name</th>
    <th style="text-align: right">IPS</th>
    <th style="text-align: right">Average</th>
    <th style="text-align: right">Deviation</th>
    <th style="text-align: right">Median</th>
    <th style="text-align: right">99th&nbsp;%</th>
  </tr>

  <tr>
    <td style="white-space: nowrap">time_zone_info</td>
    <td style="white-space: nowrap; text-align: right">2.00 M</td>
    <td style="white-space: nowrap; text-align: right">0.50 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;1521.70%</td>
    <td style="white-space: nowrap; text-align: right">0.46 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">0.58 &micro;s</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap; text-align: right">1.51 M</td>
    <td style="white-space: nowrap; text-align: right">0.66 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;1812.15%</td>
    <td style="white-space: nowrap; text-align: right">0.58 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">0.75 &micro;s</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">0.0625 M</td>
    <td style="white-space: nowrap; text-align: right">16.01 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;456.74%</td>
    <td style="white-space: nowrap; text-align: right">14.54 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">28.62 &micro;s</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">zoninfo</td>
    <td style="white-space: nowrap; text-align: right">0.0119 M</td>
    <td style="white-space: nowrap; text-align: right">83.96 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;512.58%</td>
    <td style="white-space: nowrap; text-align: right">72.87 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">242.21 &micro;s</td>
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
    <td style="white-space: nowrap;text-align: right">2.00 M</td>
    <td>&nbsp;</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap; text-align: right">1.51 M</td>
    <td style="white-space: nowrap; text-align: right">1.33x</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">0.0625 M</td>
    <td style="white-space: nowrap; text-align: right">32.09x</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">zoninfo</td>
    <td style="white-space: nowrap; text-align: right">0.0119 M</td>
    <td style="white-space: nowrap; text-align: right">168.32x</td>
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
    <td style="white-space: nowrap">0.29 KB</td>
    <td>&nbsp;</td>
  </tr>
    <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap">0.22 KB</td>
    <td>0.76x</td>
  </tr>
    <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap">1.70 KB</td>
    <td>5.86x</td>
  </tr>
    <tr>
    <td style="white-space: nowrap">zoninfo</td>
    <td style="white-space: nowrap">29.67 KB</td>
    <td>102.64x</td>
  </tr>
</table>