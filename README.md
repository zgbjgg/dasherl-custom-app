# dasherl-custom-app
A dasherl example of how integrate a complete app

This is an example of how build a Dash app using Erlang code through Dasherl and Jun. The example uses a small csv with cancer data, one column is the ICCC name, other the gender and finally the number of cases for each combination. With this file generate a simple pie graph representing the ICCC cases and their percentage.

Let's compile and generate the release:

```
$ make && make rel
```

Start the release and setup our app:

```
$ make live
```

Setup the layout and callbacks into the dasherl (into release):

```
(dasherl_custom_app@zgbjgg)1> {ok, Server} = dasherl_custom_app:setup().
{ok,<0.383.0>}
```

Done!, point your browser to: http://127.0.0.1:8000/cancer-data and you will see the pie graph, also a single dropdown, with dropdown you can filter data and recreate the pie graph, this filtering is made from erlang in the callback handler.

![Demo](https://user-images.githubusercontent.com/1471055/53260136-66d8f680-3696-11e9-9ae5-9dcb8fc2c148.gif)

Thanks!.
