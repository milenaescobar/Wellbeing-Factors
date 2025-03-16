********************************************************************************
** Determinantes Socioeconómicos de la Felicidad Global:                      **
** Un Análisis del Impacto de la Aceptación LGBT+ (2009-2014)                 **
**                                                                             **
** SCRIPT 2: ESTADÍSTICAS DESCRIPTIVAS                                        **
** Proyecto: Young Researchers Fellowship                                     **
** Última actualización: Marzo 2025                                           **
********************************************************************************

clear all                     // Limpia memoria de Stata
set more off                  // Evita pausas en resultados
capture log close             // Cierra cualquier log abierto
set linesize 100              // Mejor visualización de resultados

* Iniciar archivo de registro para documentación
log using "02_estadisticas_descriptivas.log", replace text

di "Inicio de análisis descriptivo: $S_DATE $S_TIME"

********************************************************************************
** ETAPA 1: EXPLORACIÓN UNIVARIADA DE VARIABLES CLAVE                         **
********************************************************************************

/* NOTAS DE DESARROLLO:
   - Consideramos múltiples enfoques para resumir estadísticamente las variables
   - Probamos visualizaciones alternativas para identificar patrones
   - Los resultados iniciales informaron decisiones sobre transformaciones
*/

* Cargar datos preparados
use "C:\Users\m_ile\Downloads\happiness_base_data3.dta", clear

* Primera exploración: Estadísticas descriptivas básicas
summarize

* PRUEBA 1: Comparación de comandos para estadísticas descriptivas
* Comando summarize básico
summarize lifeladder gdpwh social freedom lgbt peace unemployment inflation gini gender

* Comando summarize con estadísticas detalladas
summarize lifeladder gdpwh social freedom lgbt peace unemployment inflation gini gender, detail
* Resultado: El detallado provee información sobre asimetría y curtosis - útil para evaluar normalidad

* PRUEBA 2: Estadísticas descriptivas con distintos formatos de salida
tabstat lifeladder gdpwh social freedom lgbt peace unemployment inflation gini gender, stat(mean sd min p25 p50 p75 max n) col(stat)
* Resultado: Más compacto pero menos información sobre distribución

* PRUEBA 3: Estadísticas con formato para publicación
eststo clear
eststo: estpost summarize lifeladder gdpwh social freedom lgbt peace unemployment inflation gini gender
esttab, cells("mean(fmt(3)) sd(fmt(3)) min(fmt(3)) max(fmt(3)) count") label
* Resultado: Formato más elegante, potencialmente útil para informe final

* EXPLORACIÓN VISUAL: Distribuciones univariadas
* Histogramas para variables principales con pruebas de normalidad
foreach var of varlist lifeladder gdpwh social freedom lgbt peace unemployment inflation gini gender {
    local lbl : variable label `var'
    
    * PRUEBA A: Histograma simple
    histogram `var', title("`lbl'") 
    
    * PRUEBA B: Histograma con curva normal sobrepuesta
    histogram `var', normal title("`lbl'") subtitle("Con curva normal") 
    
    * PRUEBA C: Histograma con estimador de densidad kernel
    histogram `var', kdensity title("`lbl'") subtitle("Con densidad kernel")
    
    * PRUEBA D: Histograma con ambas curvas y bins personalizados
    histogram `var', bin(15) normal kdensity title("`lbl'") ///
        subtitle("Comparación de distribuciones teóricas") ///
        legend(on order(1 "Frecuencia" 2 "Normal" 3 "Kernel"))
    
    * PRUEBA E: Gráfico alternativo - Box plot
    graph box `var', title("`lbl'") subtitle("Diagrama de caja") 
    
    * Test formal de normalidad
    sktest `var'
    * Resultado: p<0.05 indica desviación de normalidad
}
* DECISIÓN: Para informe final usar histograma con densidad kernel (mayor claridad visual)

********************************************************************************
** ETAPA 2: ANÁLISIS DESCRIPTIVO POR GRUPOS DE INGRESOS                       **
********************************************************************************

/* NOTAS DE DESARROLLO:
   - Probamos varios métodos para comparar estadísticas entre grupos
   - Exploramos cómo presentar diferencias entre países según nivel de desarrollo
   - Los hallazgos informaron hipótesis sobre efectos heterogéneos
*/

* PRUEBA 1: Estadísticas descriptivas básicas por grupo de ingresos
tabstat lifeladder gdpwh social freedom lgbt peace unemployment inflation gini gender, by(ingresos) stat(mean sd n) nototal
* Resultado: Formato tabular básico, útil pero limitado

* PRUEBA 2: Estadísticas más detalladas por grupo con formato personalizado
forvalues g = 1/4 {
    local lbl : label income_labels `g'
    di _newline(3) "===================================================="
    di "Estadísticas para países de ingresos `lbl'"
    di "===================================================="
    summarize lifeladder gdpwh social freedom lgbt peace unemployment inflation gini gender if ingresos == `g', detail
}
* Resultado: Más completo pero menos compacto

* PRUEBA 3: Enfoque con tablas para publicación usando estout
eststo clear
forvalues g = 1/4 {
    local lbl : label income_labels `g'
    eststo g`g': quietly estpost summarize lifeladder gdpwh social freedom lgbt peace unemployment inflation gini gender if ingresos == `g'
}

* Tabla comparativa entre grupos con formato para publicación (prueba inicial)
esttab g1 g2 g3 g4, cells("mean(fmt(3)) sd(fmt(3))") label ///
    mtitle("Bajos" "Medios-bajos" "Medios-altos" "Altos") ///
    title("Comparación entre Grupos de Ingresos")
* Resultado: Mejor formato, pero aún se puede mejorar

* Tabla comparativa mejorada para publicación (formato final)
esttab g1 g2 g3 g4 using "tabla_comparativa_ingresos.rtf", ///
    cells("mean(fmt(3) label(Media)) sd(fmt(3) label(Desv. Est.)) count(fmt(0) label(N))") ///
    mtitle("Bajos" "Medios-bajos" "Medios-altos" "Altos") ///
    mgroups("Grupos de Ingresos", pattern(1 0 0 0)) ///
    title("Estadísticas Descriptivas por Grupo de Ingresos") ///
    note("Fuente: Elaboración propia con datos panel 2009-2014.") ///
    nonumber replace label
* Resultado: Formato adecuado para publicación académica

* COMPARACIÓN VISUAL ENTRE GRUPOS

* PRUEBA 1: Box plots comparativos por grupo de ingresos (variables seleccionadas)
foreach var of varlist lifeladder lgbt gdpwh social freedom {
    local lbl : variable label `var'
    graph box `var', over(ingresos) ///
        title("Distribución de `lbl' por Grupo de Ingresos") ///
        subtitle("Comparación de medianas y rangos") ///
        note("Fuente: Elaboración propia con datos panel 2009-2014") ///
        asyvars
}
* Resultado: Efectivo para visualizar diferencias en distribución

* PRUEBA 2: Gráficos de barras para valores medios por grupo (alternativa)
foreach var of varlist lifeladder lgbt gdpwh social freedom {
    local lbl : variable label `var'
    graph bar (mean) `var', over(ingresos) ///
        title("Media de `lbl' por Grupo de Ingresos") ///
        blabel(bar, format(%9.2f)) ///
        bargap(10) ///
        note("Fuente: Elaboración propia con datos panel 2009-2014")
}
* Resultado: Más simple pero menos informativo sobre distribución

* PRUEBA 3: Gráficos de barras con intervalos de confianza
foreach var of varlist lifeladder lgbt gdpwh social freedom {
    local lbl : variable label `var'
    cibar `var', over(ingresos) ///
        barlook(edgecolor(black)) ///
        graphopts(title("Media e IC 95% de `lbl' por Grupo de Ingresos") ///
                  note("Fuente: Elaboración propia con datos panel 2009-2014"))
}
* Resultado: Error - comando cibar no instalado, alternativa

* PRUEBA 3 ALTERNATIVA: Error barras con interfaz nativa
foreach var of varlist lifeladder lgbt gdpwh social freedom {
    local lbl : variable label `var'
    
    * Calcular medias e intervalos de confianza por grupo
    preserve
    collapse (mean) mean=`var' (sd) sd=`var' (count) n=`var', by(ingresos)
    generate hi = mean + invttail(n-1,0.025)*(sd / sqrt(n))
    generate lo = mean - invttail(n-1,0.025)*(sd / sqrt(n))
    
    * Gráfico con error bars
    graph twoway (bar mean ingresos, barwidth(0.7)) ///
                 (rcap hi lo ingresos, color(black)), ///
        ylabel(, angle(horizontal)) xlabel(1 "Bajos" 2 "Medios-bajos" 3 "Medios-altos" 4 "Altos") ///
        title("Media e IC 95% de `lbl' por Grupo de Ingresos") ///
        ytitle("`lbl'") xtitle("Grupo de ingresos") ///
        note("Fuente: Elaboración propia con datos panel 2009-2014") ///
        legend(off)
    restore
}
* Resultado: Método más complejo pero efectivo

* DECISIÓN FINAL: Usar box plots para comparar distribuciones (Balance entre información y simplicidad)

********************************************************************************
** ETAPA 3: ANÁLISIS DE CORRELACIONES Y RELACIONES BIVARIADAS                 **
********************************************************************************

/* NOTAS DE DESARROLLO:
   - Exploramos múltiples métodos para evaluar relaciones entre variables
   - Probamos tanto análisis numérico como visual de correlaciones
   - Identificamos correlaciones potencialmente problemáticas para el modelo
*/

* PRUEBA 1: Matriz de correlación básica
correlate lifeladder gdpwh social freedom lgbt peace unemployment inflation gini gender
* Resultado: Formato básico, difícil de interpretar visualmente

* PRUEBA 2: Matriz de correlación con significancia estadística
pwcorr lifeladder gdpwh social freedom lgbt peace unemployment inflation gini gender, sig
* Resultado: Más informativo con valores p, pero formato denso

