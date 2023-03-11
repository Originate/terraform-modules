# flatten_map

This module flattens a nested map structure into a single-level map (depth of
one), with the keys being converted to represent their path, delimited by a
provided separator. If no separator is provided, a period ("`.`") will be used
by default.

> WARNING: Due to Terraform not supporting recursion, this module is bounded to
> a nesting depth of 20. A validation error will be thrown if the value passed
> into `var.in` has a depth greater than 20 (though it isn't difficult to
> reverse-engineer this module and extend it to support a larger depth if really
> needed).

## Example

Calling the module with:

```
module "example" {
  source = "github.com/Originate/terraform-modules//terraform/flatten_map?ref=v1"

  in = {
    a = "foo"
    b = {
      d = 11
    }
    c = {
      e = true
      f = {
        g = {
          h = ["bar", "baz"]
        }
      }
    }
  }
  separator = "/"
}
```

will give an output of:

```
out = {
  "a" = "foo"
  "b/d" = 11
  "c/e" = true
  "c/f/g/h" = [
    "bar",
    "baz",
  ]
}
```
