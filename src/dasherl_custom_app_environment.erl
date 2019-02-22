-module(dasherl_custom_app_environment).

-behaviour(gen_server).

%% API
-export([start_link/0,
    stop/0,
    worker/0,
    dataframe/0]).

%% gen_server callbacks
-export([init/1,
    handle_call/3,
    handle_cast/2,
    handle_info/2,
    terminate/2,
    code_change/3]).

-record(state, {dataframe :: undefined,
    worker :: undefined}).

start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

stop() ->
    gen_server:call(?MODULE, stop_link).

worker() ->
    gen_server:call(?MODULE, worker).

dataframe() ->
    gen_server:call(?MODULE, dataframe).

init([]) ->
    process_flag(trap_exit, true),
    {ok, JunWorker} = jun_worker:start_link(),
    CsvPath = code:priv_dir(dasherl_custom_app) ++ "/cancer_data_counter.csv",
    {ok, {_, Dataframe}} = jun_pandas:read_csv(JunWorker, list_to_atom(CsvPath), []),
    {ok, #state{worker = JunWorker, dataframe = Dataframe}}.

handle_call(stop_link, _From, State) ->
    {stop, normal, ok, State};

handle_call(worker, _From, State=#state{worker = JunWorker}) ->
    {reply, {ok, JunWorker}, State};

handle_call(dataframe, _From, State=#state{dataframe = Dataframe}) ->
    {reply, {ok, Dataframe}, State};

handle_call(_Request, _From, State) ->    
    {reply, ok, State}.

handle_cast(_Request, State) ->
    {noreply, State}.

handle_info(_Info, State) ->
    {noreply, State}.

terminate(_Reason, State) ->
    JunWorker = State#state.worker,
    ok = jun_worker:stop_link(JunWorker),
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%% ===================================
%% Internal Funcionts
%% ===================================
