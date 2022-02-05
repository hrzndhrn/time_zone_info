
# Benchmark

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
    <td style="white-space: nowrap">1.13.2</td>
  </tr><tr>
    <th style="white-space: nowrap">Erlang Version</th>
    <td style="white-space: nowrap">24.2.1</td>
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
    <td style="white-space: nowrap; text-align: right">1328.72 K</td>
    <td style="white-space: nowrap; text-align: right">0.75 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;2725.23%</td>
    <td style="white-space: nowrap; text-align: right">0.99 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">0.99 &micro;s</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap; text-align: right">545.36 K</td>
    <td style="white-space: nowrap; text-align: right">1.83 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;694.41%</td>
    <td style="white-space: nowrap; text-align: right">1.99 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">1.99 &micro;s</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">11.03 K</td>
    <td style="white-space: nowrap; text-align: right">90.62 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;5.94%</td>
    <td style="white-space: nowrap; text-align: right">87.99 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">100.99 &micro;s</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">zoninfo</td>
    <td style="white-space: nowrap; text-align: right">4.23 K</td>
    <td style="white-space: nowrap; text-align: right">236.40 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;26.04%</td>
    <td style="white-space: nowrap; text-align: right">230.99 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">389.99 &micro;s</td>
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
    <td style="white-space: nowrap;text-align: right">1328.72 K</td>
    <td>&nbsp;</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap; text-align: right">545.36 K</td>
    <td style="white-space: nowrap; text-align: right">2.44x</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">11.03 K</td>
    <td style="white-space: nowrap; text-align: right">120.41x</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">zoninfo</td>
    <td style="white-space: nowrap; text-align: right">4.23 K</td>
    <td style="white-space: nowrap; text-align: right">314.11x</td>
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
    <td style="white-space: nowrap">1.87 KB</td>
    <td>2.75x</td>
  </tr>
    <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap">117.59 KB</td>
    <td>173.0x</td>
  </tr>
    <tr>
    <td style="white-space: nowrap">zoninfo</td>
    <td style="white-space: nowrap">23.89 KB</td>
    <td>35.15x</td>
  </tr>
</table>



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
    <td style="white-space: nowrap; text-align: right">1.56 M</td>
    <td style="white-space: nowrap; text-align: right">0.64 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;2645.58%</td>
    <td style="white-space: nowrap; text-align: right">0.99 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">0.99 &micro;s</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">time_zone_info</td>
    <td style="white-space: nowrap; text-align: right">1.31 M</td>
    <td style="white-space: nowrap; text-align: right">0.76 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;3419.82%</td>
    <td style="white-space: nowrap; text-align: right">0.99 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">0.99 &micro;s</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">0.0580 M</td>
    <td style="white-space: nowrap; text-align: right">17.24 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;26.63%</td>
    <td style="white-space: nowrap; text-align: right">16.99 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">19.99 &micro;s</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">zoninfo</td>
    <td style="white-space: nowrap; text-align: right">0.00431 M</td>
    <td style="white-space: nowrap; text-align: right">231.82 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;20.78%</td>
    <td style="white-space: nowrap; text-align: right">225.99 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">377.99 &micro;s</td>
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
    <td style="white-space: nowrap;text-align: right">1.56 M</td>
    <td>&nbsp;</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">time_zone_info</td>
    <td style="white-space: nowrap; text-align: right">1.31 M</td>
    <td style="white-space: nowrap; text-align: right">1.19x</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">0.0580 M</td>
    <td style="white-space: nowrap; text-align: right">26.96x</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">zoninfo</td>
    <td style="white-space: nowrap; text-align: right">0.00431 M</td>
    <td style="white-space: nowrap; text-align: right">362.55x</td>
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
    <td style="white-space: nowrap">2.89 KB</td>
    <td>7.4x</td>
  </tr>
    <tr>
    <td style="white-space: nowrap">zoninfo</td>
    <td style="white-space: nowrap">22.39 KB</td>
    <td>57.32x</td>
  </tr>
</table>



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
    <td style="white-space: nowrap; text-align: right">1.49 M</td>
    <td style="white-space: nowrap; text-align: right">0.67 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;3502.24%</td>
    <td style="white-space: nowrap; text-align: right">0.99 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">0.99 &micro;s</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">time_zone_info</td>
    <td style="white-space: nowrap; text-align: right">1.35 M</td>
    <td style="white-space: nowrap; text-align: right">0.74 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;3572.96%</td>
    <td style="white-space: nowrap; text-align: right">0.99 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">0.99 &micro;s</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">0.0522 M</td>
    <td style="white-space: nowrap; text-align: right">19.16 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;26.57%</td>
    <td style="white-space: nowrap; text-align: right">18.99 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">23.99 &micro;s</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">zoninfo</td>
    <td style="white-space: nowrap; text-align: right">0.00431 M</td>
    <td style="white-space: nowrap; text-align: right">231.89 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;20.56%</td>
    <td style="white-space: nowrap; text-align: right">226.99 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">379.99 &micro;s</td>
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
    <td style="white-space: nowrap;text-align: right">1.49 M</td>
    <td>&nbsp;</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">time_zone_info</td>
    <td style="white-space: nowrap; text-align: right">1.35 M</td>
    <td style="white-space: nowrap; text-align: right">1.11x</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">0.0522 M</td>
    <td style="white-space: nowrap; text-align: right">28.64x</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">zoninfo</td>
    <td style="white-space: nowrap; text-align: right">0.00431 M</td>
    <td style="white-space: nowrap; text-align: right">346.61x</td>
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
    <td style="white-space: nowrap">5.28 KB</td>
    <td>11.86x</td>
  </tr>
    <tr>
    <td style="white-space: nowrap">zoninfo</td>
    <td style="white-space: nowrap">22.47 KB</td>
    <td>50.46x</td>
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
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap; text-align: right">44.44 K</td>
    <td style="white-space: nowrap; text-align: right">22.50 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;162.34%</td>
    <td style="white-space: nowrap; text-align: right">19.99 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">86.99 &micro;s</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">time_zone_info</td>
    <td style="white-space: nowrap; text-align: right">40.21 K</td>
    <td style="white-space: nowrap; text-align: right">24.87 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;57.46%</td>
    <td style="white-space: nowrap; text-align: right">21.99 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">95.99 &micro;s</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">zoninfo</td>
    <td style="white-space: nowrap; text-align: right">4.33 K</td>
    <td style="white-space: nowrap; text-align: right">231.08 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;21.84%</td>
    <td style="white-space: nowrap; text-align: right">224.99 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">378.99 &micro;s</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">3.05 K</td>
    <td style="white-space: nowrap; text-align: right">328.13 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;33.96%</td>
    <td style="white-space: nowrap; text-align: right">361.99 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">797.99 &micro;s</td>
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
    <td style="white-space: nowrap;text-align: right">44.44 K</td>
    <td>&nbsp;</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">time_zone_info</td>
    <td style="white-space: nowrap; text-align: right">40.21 K</td>
    <td style="white-space: nowrap; text-align: right">1.11x</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">zoninfo</td>
    <td style="white-space: nowrap; text-align: right">4.33 K</td>
    <td style="white-space: nowrap; text-align: right">10.27x</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">3.05 K</td>
    <td style="white-space: nowrap; text-align: right">14.58x</td>
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
    <td style="white-space: nowrap">16.72 KB</td>
    <td>&nbsp;</td>
  </tr>
    <tr>
    <td style="white-space: nowrap">time_zone_info</td>
    <td style="white-space: nowrap">19.91 KB</td>
    <td>1.19x</td>
  </tr>
    <tr>
    <td style="white-space: nowrap">zoninfo</td>
    <td style="white-space: nowrap">22.39 KB</td>
    <td>1.34x</td>
  </tr>
    <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap">13.38 KB</td>
    <td>0.8x</td>
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
    <td style="white-space: nowrap; text-align: right">856.07 K</td>
    <td style="white-space: nowrap; text-align: right">1.17 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;1602.59%</td>
    <td style="white-space: nowrap; text-align: right">0.99 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">1.99 &micro;s</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap; text-align: right">461.84 K</td>
    <td style="white-space: nowrap; text-align: right">2.17 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;635.93%</td>
    <td style="white-space: nowrap; text-align: right">1.99 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">2.99 &micro;s</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">66.14 K</td>
    <td style="white-space: nowrap; text-align: right">15.12 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;38.41%</td>
    <td style="white-space: nowrap; text-align: right">14.99 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">17.99 &micro;s</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">zoninfo</td>
    <td style="white-space: nowrap; text-align: right">3.95 K</td>
    <td style="white-space: nowrap; text-align: right">252.96 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;21.92%</td>
    <td style="white-space: nowrap; text-align: right">247.99 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">415.99 &micro;s</td>
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
    <td style="white-space: nowrap;text-align: right">856.07 K</td>
    <td>&nbsp;</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap; text-align: right">461.84 K</td>
    <td style="white-space: nowrap; text-align: right">1.85x</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">66.14 K</td>
    <td style="white-space: nowrap; text-align: right">12.94x</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">zoninfo</td>
    <td style="white-space: nowrap; text-align: right">3.95 K</td>
    <td style="white-space: nowrap; text-align: right">216.56x</td>
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
    <td style="white-space: nowrap">2.89 KB</td>
    <td>5.07x</td>
  </tr>
    <tr>
    <td style="white-space: nowrap">zoninfo</td>
    <td style="white-space: nowrap">30.32 KB</td>
    <td>53.16x</td>
  </tr>
</table>


