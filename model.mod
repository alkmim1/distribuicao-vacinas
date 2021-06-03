set estado;

param numVacinas;
param populacao {j in estado}; 
param casos_acumulados {j in estado};
param obitos_acumulados {j in estado};
param vacinados {j in estado};
 
# Soma dos totais das variáveis para serem utilizadas nas restrições
param populacao_total :=  sum{j in estado} populacao[j];
param casos_acumulados_total :=  sum{j in estado} casos_acumulados[j]; 
param obitos_acumulados_total :=  sum{j in estado} obitos_acumulados[j];
param vacinados_total := sum{j in estado} vacinados[j]; 


var qtd_vacinas{j in estado} integer >= 0; # total de vacinas por estado


# A função objetivo considerará para cada estado a fórmula: peso * numero_vacinas 
#==============================================================================================================
# Considerando o número de casos como base para o cálculo do peso
# peso = (casos_do_estado_por_estado / casos_acumulados_total)

# PARA TESTAR CONSIDERANDO O NÚMERO DE CASOS ACUMULADOS DESCOMENTE AS PRÓXIMAS DUAS LINHAS
# maximize vacinas {j in estado} : round((casos_acumulados[j] / casos_acumulados_total) * numVacinas);
# subject to qtd {j in estado} : (casos_acumulados[j] / casos_acumulados_total) * numVacinas <= populacao[j];

#==============================================================================================================
# Considerando o número de óbitos como base para o cálculo do peso
# peso = (obitos_acumulados_por_estado / obitos_acumulados_total)

# PARA TESTAR CONSIDERANDO O NÚMERO DE ÓBITOS ACUMULADOS DESCOMENTE AS PRÓXIMAS DUAS LINHAS
maximize vacinas {j in estado} : round((obitos_acumulados[j] / obitos_acumulados_total) * numVacinas);
subject to qtd {j in estado} : (obitos_acumulados[j] / obitos_acumulados_total) * numVacinas <= populacao[j];

#==============================================================================================================
# Considerando o número de óbitos como base para o cálculo do peso
# peso = (populacao_por_estado / populacao_total)

# PARA TESTAR CONSIDERANDO O NÚMERO DE HABITANTES DESCOMENTE AS PRÓXIMAS DUAS LINHAS
#maximize vacinas {j in estado} : round((populacao[j] / populacao_total) * numVacinas);
#subject to qtd {j in estado} : (populacao[j] / populacao_total) * numVacinas <= populacao[j];

#==============================================================================================================
# Considerando o número de vacinados como base para o cálculo do peso
# peso = ((populacao_por_estado - vacinados_por_estado) / populacao_total)

# PARA TESTAR CONSIDERANDO O NÚMERO DE HABITANTES VACINADOS DESCOMENTE AS PRÓXIMAS DUAS LINHAS
#maximize vacinas {j in estado} : round(((populacao[j] - vacinados[j]) / populacao_total) * numVacinas);
#subject to qtd {j in estado} : ((populacao[j] - vacinados[j]) / populacao_total) * numVacinas <= populacao[j];

#==============================================================================================================

# soma total de vacinas <= numVacinas;
subject to qtd : sum {j in estado} qtd_vacinas[j] <= numVacinas;

# num de pessoas a serem vacinadas >= numVacinas enviadas para o estado
subject to nao_vacinados {j in estado} : qtd_vacinas[j] <= (populacao[j] - vacinados[j]);

# casos_acumulados <= populacao
subject to casos {j in estado} : casos_acumulados[j] <= populacao[j];

# obitos_acumulados <= populacao
subject to mortes {j in estado} : obitos_acumulados[j] <= populacao[j];

# vacinacao rebanho atingida
subject to vacinacao_rebanho {j in estado} : (vacinados[j] + qtd_vacinas[j]) <= (0.7 * populacao[j]);


data data.dat;
option solver cplex;
solve;
display vacinas;