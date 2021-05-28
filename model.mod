set estado;

param numVacinas;
#param numMinVacinas;
param populacao {j in estado}; 
param casos_acumulados {j in estado};
param obitos_acumulados {j in estado};
param vacinados {j in estado}; 
param populacao_total :=  sum{j in estado} populacao[j];
param casos_acumulados_total :=  sum{j in estado} casos_acumulados[j]; 
param obitos_acumulados_total :=  sum{j in estado} obitos_acumulados[j];
param vacinados_total := sum{j in estado} vacinados[j]; 

var qtd_vacinas{j in estado} integer >= 0; # total de vacinas por estado

# maximize vacinas: sum{j in estado} numVacinas * ((populacao[j] - vacinados[j]) / populacaoTotal);
#maximize vacinas: sum{j in estado} ((populacao[j] - vacinados[j]) / populacao_total) * qtd_vacinas[j];

maximize vacinas: sum{j in estado} qtd_vacinas[j];
# soma total de vacinas <= numVacinas;
subject to qtd : sum {j in estado} qtd_vacinas[j] <= numVacinas;

#subject to qtd : sum {j in estado} qtd_vacinas[j] >= numMinVacinas;

# num de pessoas a serem vacinadas >= numVacinas enviadas para o estado
subject to nao_vacinados {j in estado} : qtd_vacinas[j] <= (populacao[j] - vacinados[j]);

# casos_acumulados <= populacao
subject to casos {j in estado} : casos_acumulados[j] <= populacao[j];

# obitos_acumulados <= populacao
subject to mortes {j in estado} : obitos_acumulados[j] <= populacao[j];

# vacinacao rebanho atingida
subject to vacinacao_rebanho {j in estado} : (vacinados[j] + qtd_vacinas[j]) <= (0.7 * populacao[j]);


data t.dat;
option solver cplex;
solve;
display vacinas;
display qtd_vacinas;
display nao_vacinados;
display casos;
display mortes;