
<!-- README.md is generated from README.Rmd. Please edit that file -->

# nodegraph

The goal of nodegraph is to provide infrastructure for delaying matrix
and array operations.

## Installation

``` r
devtools::install_github("DavisVaughan/nodegraph")
```

## Example

nodegraph “remembers” the operations that you perform on your
matrix/array, but doesn’t actually perform the computation. It performs
all of the computations at once when you call `compute()`, computing any
necessary dependencies and storing them as it goes.

``` r
library(nodegraph)
```

Create a `delay_array` to get started.

``` r
mat <- matrix(1:10)

delay_mat <- as_delay_array(mat)
delay_mat
#> <delay_array>
#>       [,1]
#>  [1,]    1
#>  [2,]    2
#>  [3,]    3
#>  [4,]    4
#>  [5,]    5
#>  [6,]    6
#>  [7,]    7
#>  [8,]    8
#>  [9,]    9
#> [10,]   10
```

It looks similar to a matrix, but under the hood it’s pretty different.
Let’s try and do something with it.

``` r
delay_mat2 <- as_delay_array(matrix(1:10))

res <- delay_mat + delay_mat2
res
#> <delay_array>
#>       [,1]
#>  [1,]  ?  
#>  [2,]  ?  
#>  [3,]  ?  
#>  [4,]  ?  
#>  [5,]  ?  
#>  [6,]  ?  
#>  [7,]  ?  
#>  [8,]  ?  
#>  [9,]  ?  
#> [10,]  ?
```

The output of the `+` operation knows the shape, but not the actual
result. This is because it has not yet been computed.

You can add more operations, and they get chained together. R matrices
are promoted to `delay_array`s before the computation takes place.

``` r
res2 <- res / matrix(5, nrow = 10)
res2
#> <delay_array>
#>       [,1]
#>  [1,]  ?  
#>  [2,]  ?  
#>  [3,]  ?  
#>  [4,]  ?  
#>  [5,]  ?  
#>  [6,]  ?  
#>  [7,]  ?  
#>  [8,]  ?  
#>  [9,]  ?  
#> [10,]  ?
```

To actually perform the computation, call `compute()`. It will compute
any child dependencies and itself. Along the way, it will set the values
so it doesn’t have to calculate them again.

``` r
compute(res2)
#> <delay_array>
#>       [,1]
#>  [1,]  0.4
#>  [2,]  0.8
#>  [3,]  1.2
#>  [4,]  1.6
#>  [5,]  2.0
#>  [6,]  2.4
#>  [7,]  2.8
#>  [8,]  3.2
#>  [9,]  3.6
#> [10,]  4.0
```

Look, it remembered that `res2` has been computed\!

``` r
res2
#> <delay_array>
#>       [,1]
#>  [1,]  0.4
#>  [2,]  0.8
#>  [3,]  1.2
#>  [4,]  1.6
#>  [5,]  2.0
#>  [6,]  2.4
#>  [7,]  2.8
#>  [8,]  3.2
#>  [9,]  3.6
#> [10,]  4.0
```

Look, `res` (a dependency of `res2`) has been computed now too\!

``` r
res
#> <delay_array>
#>       [,1]
#>  [1,]    2
#>  [2,]    4
#>  [3,]    6
#>  [4,]    8
#>  [5,]   10
#>  [6,]   12
#>  [7,]   14
#>  [8,]   16
#>  [9,]   18
#> [10,]   20
```

## Extensibility

`nodegraph` is being designed with extensibility in mind. If you create
a new class that inherits from `delay_array`, then you can define
methods for the following 2 functions to get the laziness you see here:

  - `compute_engine()` - Given a set of *known* children (arguments),
    and an operation (like `+`), this defines how your engine computes
    the result of that operation.

  - `compute_dim_engine()` - Given a set of arguments for an operation
    (i.e. `x` and `y` in the expression `x+y`), this defines what the
    dimension of the output should be. At first glance, you might think
    this is the same no matter what backend you use, but some backends
    allow for *broadcasting* which can change the dimensions
    substantially. The default method uses R’s strict dimensionality
    rules.

## Eager execution

If you want to enable eager execution (for debugging or whatever
reason), you can do so with `set_computation_type("eager")` which will
result in the computation being performed immediately:

``` r
delay_mat + delay_mat2
#> <delay_array>
#>       [,1]
#>  [1,]  ?  
#>  [2,]  ?  
#>  [3,]  ?  
#>  [4,]  ?  
#>  [5,]  ?  
#>  [6,]  ?  
#>  [7,]  ?  
#>  [8,]  ?  
#>  [9,]  ?  
#> [10,]  ?

set_computation_type("eager")

delay_mat + delay_mat2
#> <delay_array>
#>       [,1]
#>  [1,]    2
#>  [2,]    4
#>  [3,]    6
#>  [4,]    8
#>  [5,]   10
#>  [6,]   12
#>  [7,]   14
#>  [8,]   16
#>  [9,]   18
#> [10,]   20

set_computation_type("lazy")

delay_mat + delay_mat2
#> <delay_array>
#>       [,1]
#>  [1,]  ?  
#>  [2,]  ?  
#>  [3,]  ?  
#>  [4,]  ?  
#>  [5,]  ?  
#>  [6,]  ?  
#>  [7,]  ?  
#>  [8,]  ?  
#>  [9,]  ?  
#> [10,]  ?
```
