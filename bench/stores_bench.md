
# Benchmark

This benchmark compares the different `DataStores` available in
`TimeZoneInfo`.

The `TimeZoneInfo` will be tested in three different configurations.
Each version uses a different strategy to keep the data available.
- `pst` is using
  [`:persistent_term`](https://erlang.org/doc/man/persistent_term.html)
- `ets` is using `:ets`
  [(Erlang Term Storage)](https://erlang.org/doc/man/ets.html)
- `map` is using a `GenServer` with a `Map` as state. This
  version isn't an available configuration in `TimeZoneInfo`. The
  `GenServer` version is otherwise only used in the tests.


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
    <td style="white-space: nowrap">30 s</td>
  </tr><tr>
    <th>:parallel</th>
    <td style="white-space: nowrap">1</td>
  </tr><tr>
    <th>:warmup</th>
    <td style="white-space: nowrap">2 s</td>
  </tr>
</table>

## Statistics




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
    <td style="white-space: nowrap">pst</td>
    <td style="white-space: nowrap; text-align: right">177.85 K</td>
    <td style="white-space: nowrap; text-align: right">5.62 μs</td>
    <td style="white-space: nowrap; text-align: right">±529.01%</td>
    <td style="white-space: nowrap; text-align: right">4.90 μs</td>
    <td style="white-space: nowrap; text-align: right">14.90 μs</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">ets</td>
    <td style="white-space: nowrap; text-align: right">22.19 K</td>
    <td style="white-space: nowrap; text-align: right">45.06 μs</td>
    <td style="white-space: nowrap; text-align: right">±45.71%</td>
    <td style="white-space: nowrap; text-align: right">39.90 μs</td>
    <td style="white-space: nowrap; text-align: right">116.90 μs</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">map</td>
    <td style="white-space: nowrap; text-align: right">17.76 K</td>
    <td style="white-space: nowrap; text-align: right">56.31 μs</td>
    <td style="white-space: nowrap; text-align: right">±68.46%</td>
    <td style="white-space: nowrap; text-align: right">47.90 μs</td>
    <td style="white-space: nowrap; text-align: right">130.90 μs</td>
  </tr>

</table>


Comparison

<table style="width: 1%">
  <tr>
    <th>Name</th>
    <th style="text-align: right">IPS</th>
    <th style="text-align: right">Slower</th>
  <tr>
    <td style="white-space: nowrap">pst</td>
    <td style="white-space: nowrap;text-align: right">177.85 K</td>
    <td>&nbsp;</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">ets</td>
    <td style="white-space: nowrap; text-align: right">22.19 K</td>
    <td style="white-space: nowrap; text-align: right">8.01x</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">map</td>
    <td style="white-space: nowrap; text-align: right">17.76 K</td>
    <td style="white-space: nowrap; text-align: right">10.02x</td>
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
    <td style="white-space: nowrap">pst</td>
    <td style="white-space: nowrap">856 B</td>
<td>&nbsp;</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">ets</td>
    <td style="white-space: nowrap">880 B</td>
    <td>1.03x</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">map</td>
    <td style="white-space: nowrap">928 B</td>
    <td>1.08x</td>
  </tr>

</table>


<hr/>

