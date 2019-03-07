-module(dasherl_custom_app_mod_handler).

-behaviour(dasherl_handler).

-export([layout/0, callbacks/0, update_pie_gender/2]).

layout() ->
    OptionsDropdown = [[{label, 'All'}, {value, 'all'}], [{label, 'Female'}, {value, 'F'}], [{label, 'Male'}, {value, 'M'}]],
    Dropdown = dasherl_components:dropdown([{id, 'gender'}, {options, OptionsDropdown}, {value, 'all'}]),
    Graph = dasherl_components:graph([{id, 'pie-by-iccc'}]),
    dasherl_components:divc([{children, [Dropdown, Graph]}]).

callbacks() ->
    Output = dasherl_dependencies:output('pie-by-iccc', 'figure'),
    Input = dasherl_dependencies:input('gender', 'value'),
    [{Output, [Input], 'update_pie_gender', ?MODULE, update_pie_gender}].    

update_pie_gender(_Bind, {GenderFilter}) ->
    % get dataframe in order to regenerate our figure
    {ok, Dataframe} = dasherl_custom_app_environment:dataframe(),
    {ok, JunWorker} = dasherl_custom_app_environment:worker(),
    FilteredDataframe = case GenderFilter of
        "all" -> Dataframe;
        _     ->
            Query = list_to_atom("gender == " ++ GenderFilter),
            {ok, {_, GenderDataframe}} = jun_pandas:legacy_query(JunWorker, Dataframe, Query, []),
            GenderDataframe
    end,
    {ok, {_, Labels}} = jun_pandas:single_selection(JunWorker, FilteredDataframe, 'iccc', []),
    {ok, {_, Values}} = jun_pandas:single_selection(JunWorker, FilteredDataframe, 'total', []),
    {data, [[{labels, Labels}, {values, Values}, {type, pie}]]}.
