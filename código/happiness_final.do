********************************************************************************
** Determinantes Socioeconómicos de la Felicidad Global:                      **
** Un Análisis del Impacto de la Aceptación LGBT+ (2009-2014)                 **
**                                                                             **
** Código Stata para análisis de datos de panel                               **
** Proyecto: Young Researchers Fellowship                                     **
** Última actualización: Marzo 2025                                           **
********************************************************************************

clear all                     // Limpia memoria de Stata
set more off                  // Evita pausas en resultados
capture log close             // Cierra cualquier log abierto
set linesize 100              // Mejor visualización de resultados

* Iniciar archivo de registro para documentación
log using "felicidad_global_analisis.log", replace text

********************************************************************************
** SECCIÓN 1: CARGA Y PREPARACIÓN DE DATOS                                    **
********************************************************************************

* Cargar la base de datos principal
use "happiness_base_data3.dta", clear

* Examinar estructura de los datos
describe
codebook, compact

* Configurar estructura de panel país-año 
encode code, gen(code_num)
xtset code_num year
xtdescribe

* Crear variable para región/continente - método más robusto por regiones
gen continent = .

* América del Norte
replace continent = 1 if inlist(code, "USA", "CAN", "MEX")
replace continent = 1 if inlist(code, "GTM", "SLV", "HND", "NIC", "CRI", "PAN")

* América del Sur
replace continent = 2 if inlist(code, "COL", "VEN", "ECU", "PER", "BOL")
replace continent = 2 if inlist(code, "BRA", "CHL", "ARG", "PRY", "URY")

* Europa Occidental
replace continent = 3 if inlist(code, "GBR", "IRL", "FRA", "DEU", "NLD", "BEL")
replace continent = 3 if inlist(code, "CHE", "AUT", "ESP", "PRT", "ITA", "GRC")
replace continent = 3 if inlist(code, "NOR", "SWE", "FIN", "DNK", "ISL")

* Europa Oriental
replace continent = 3 if inlist(code, "POL", "CZE", "SVK", "HUN", "ROU", "BGR")
replace continent = 3 if inlist(code, "UKR", "BLR", "RUS", "SRB", "HRV", "SVN")

* África
replace continent = 4 if inlist(code, "MAR", "DZA", "TUN", "LBY", "EGY", "SDN")
replace continent = 4 if inlist(code, "SEN", "MLI", "NER", "NGA", "CMR", "GAB")
replace continent = 4 if inlist(code, "KEN", "TZA", "UGA", "RWA", "ETH", "ZAF")

* Asia Occidental
replace continent = 5 if inlist(code, "TUR", "IRN", "IRQ", "SAU", "YEM", "SYR")
replace continent = 5 if inlist(code, "ISR", "JOR", "LBN", "ARE", "QAT", "KWT")

* Asia Oriental y Sureste Asiático
replace continent = 5 if inlist(code, "CHN", "JPN", "KOR", "MNG", "TWN", "HKG")
replace continent = 5 if inlist(code, "VNM", "LAO", "KHM", "THA", "MMR", "MYS")
replace continent = 5 if inlist(code, "IDN", "PHL", "SGP", "BRN")

* Asia Meridional
replace continent = 5 if inlist(code, "IND", "PAK", "BGD", "NPL", "BTN", "LKA")
replace continent = 5 if inlist(code, "AFG")

* Oceanía
replace continent = 6 if inlist(code, "AUS", "NZL", "PNG", "FJI", "SLB", "VUT")

* Etiquetar variable continente
label define continent_lbl 1 "América" 2 "América del Sur" 3 "Europa" 4 "África" 5 "Asia" 6 "Oceanía"
label values continent continent_lbl
tab continent, missing

* Etiquetar variables para mejor interpretación
label variable lifeladder "Índice de Felicidad Mundial"
label variable gdpwh "PIB per cápita (log)"
label variable social "Capital social"
label variable freedom "Libertad percibida en decisiones"
label variable lgbt "Índice de aceptación LGBT+"
label variable peace "Índice de Paz Global (transformado)"
label variable unemployment "Tasa de desempleo (%)"
label variable inflation "Tasa de inflación (%)"
label variable gini "Coeficiente de Gini"
label variable gender "Índice de desigualdad de género"

* Definir etiquetas para grupos de ingresos según clasificación del Banco Mundial
label define income_labels 1 "Bajos" 2 "Medios-bajos" 3 "Medios-altos" 4 "Altos"
label values ingresos income_labels

* Eliminar observaciones con valores faltantes en variables clave
drop if missing(lifeladder, gdpwh, social, freedom, lgbt, peace, unemployment, inflation, gini, gender)

* CENTRADO DE VARIABLES: Método para reducir multicolinealidad
* Esto no cambia el significado teórico del modelo pero mejora la estimación estadística
summarize gdpwh
gen gdpwh_c = gdpwh - r(mean)
label variable gdpwh_c "PIB per cápita (log) centrado"

summarize lgbt
gen lgbt_c = lgbt - r(mean)
label variable lgbt_c "Índice de aceptación LGBT+ centrado"

* Crear términos cuadráticos e interacciones con variables centradas
* Esto reduce drásticamente la multicolinealidad
gen gdpwh_c_sq = gdpwh_c^2
label variable gdpwh_c_sq "PIB per cápita al cuadrado (centrado)"

gen gdpwh_lgbt_c = gdpwh_c * lgbt_c
label variable gdpwh_lgbt_c "Interacción PIB-LGBT+ (centrados)"

* Verificar tamaño final de la muestra por grupo de ingresos
count
tab ingresos

********************************************************************************
** SECCIÓN 2: ESTADÍSTICAS DESCRIPTIVAS                                       **
********************************************************************************

* Estadísticas descriptivas generales de todas las variables
summarize lifeladder gdpwh_c social freedom lgbt_c peace unemployment inflation gini gender

* Estadísticas descriptivas por grupo de ingresos
by ingresos, sort: summarize lifeladder gdpwh_c social freedom lgbt_c peace unemployment inflation gini gender

* Matriz de correlación para evaluar relaciones bivariadas
corr lifeladder gdpwh_c social freedom lgbt_c peace unemployment inflation gini gender
pwcorr lifeladder gdpwh_c social freedom lgbt_c peace unemployment inflation gini gender, sig

* Correlaciones por grupo de ingresos
levelsof ingresos, local(grupos)
foreach grupo in `grupos' {
    di "Correlaciones para el grupo de ingresos: `grupo'"
    corr lifeladder gdpwh_c social freedom lgbt_c peace unemployment inflation gini gender if ingresos==`grupo', means
}

* Gráficos de dispersión principales (con variables originales para facilitar interpretación)
* 1. Relación entre felicidad y PIB por grupo de ingresos
twoway (scatter lifeladder gdpwh if ingresos==1, mcolor(blue) msymbol(circle)) ///
       (scatter lifeladder gdpwh if ingresos==2, mcolor(green) msymbol(diamond)) ///
       (scatter lifeladder gdpwh if ingresos==3, mcolor(orange) msymbol(square)) ///
       (scatter lifeladder gdpwh if ingresos==4, mcolor(red) msymbol(triangle)) ///
       (lfit lifeladder gdpwh if ingresos==1, lcolor(blue)) ///
       (lfit lifeladder gdpwh if ingresos==2, lcolor(green)) ///
       (lfit lifeladder gdpwh if ingresos==3, lcolor(orange)) ///
       (lfit lifeladder gdpwh if ingresos==4, lcolor(red)), ///
       title("Felicidad vs PIB per cápita por Grupo de Ingresos", size(medium)) ///
       subtitle("Panel de Datos 2009-2014", size(small)) ///
       xtitle("PIB per cápita (log)") ytitle("Índice de Felicidad Mundial") ///
       legend(order(1 "Ingresos bajos" 2 "Ingresos medios-bajos" ///
              3 "Ingresos medios-altos" 4 "Ingresos altos")) ///
       scheme(s2color) ///
       graphregion(color(white)) bgcolor(white) plotregion(color(white))

* 2. Relación entre felicidad y aceptación LGBT+ por grupo de ingresos
twoway (scatter lifeladder lgbt if ingresos==1, mcolor(blue) msymbol(circle)) ///
       (scatter lifeladder lgbt if ingresos==2, mcolor(green) msymbol(diamond)) ///
       (scatter lifeladder lgbt if ingresos==3, mcolor(orange) msymbol(square)) ///
       (scatter lifeladder lgbt if ingresos==4, mcolor(red) msymbol(triangle)) ///
       (lfit lifeladder lgbt if ingresos==1, lcolor(blue)) ///
       (lfit lifeladder lgbt if ingresos==2, lcolor(green)) ///
       (lfit lifeladder lgbt if ingresos==3, lcolor(orange)) ///
       (lfit lifeladder lgbt if ingresos==4, lcolor(red)), ///
       title("Felicidad vs Aceptación LGBT+ por Grupo de Ingresos", size(medium)) ///
       subtitle("Panel de Datos 2009-2014", size(small)) ///
       xtitle("Índice de Aceptación LGBT+") ytitle("Índice de Felicidad Mundial") ///
       legend(order(1 "Ingresos bajos" 2 "Ingresos medios-bajos" ///
              3 "Ingresos medios-altos" 4 "Ingresos altos")) ///
       scheme(s2color) ///
       graphregion(color(white)) bgcolor(white) plotregion(color(white))

* 3. Evaluación de forma funcional para PIB (test visual Paradoja de Easterlin)
twoway (scatter lifeladder gdpwh, mcolor(navy%40) msymbol(circle)) ///
       (lfit lifeladder gdpwh, lcolor(red) lwidth(thick)) ///
       (qfit lifeladder gdpwh, lcolor(green) lwidth(thick)), ///
       title("Relación No Lineal entre Felicidad y PIB per cápita", size(medium)) ///
       subtitle("Test de la Paradoja de Easterlin", size(small)) ///
       xtitle("PIB per cápita (log)") ytitle("Índice de Felicidad Mundial") ///
       legend(order(2 "Ajuste lineal" 3 "Ajuste cuadrático")) ///
       scheme(s2color) ///
       graphregion(color(white)) bgcolor(white) plotregion(color(white))

********************************************************************************
** SECCIÓN 3: ANÁLISIS ECONOMÉTRICO PRINCIPAL                                 **
********************************************************************************

* Test de Hausman para decidir entre efectos fijos (EF) o aleatorios (EA)
xtreg lifeladder gdpwh_c social freedom lgbt_c peace unemployment inflation gini gender, fe
estimates store fixed
xtreg lifeladder gdpwh_c social freedom lgbt_c peace unemployment inflation gini gender, re
estimates store random
hausman fixed random, sigmamore
* Resultado: p<0.05 indica que debemos usar efectos fijos (rechazamos H0)

* MODELO PRINCIPAL INTEGRADO CON VARIABLES CENTRADAS
* Incorpora forma cuadrática del PIB y efecto moderador del desarrollo sobre aceptación LGBT+
* Los errores estándar robustos agrupados por país corrigen heteroscedasticidad y autocorrelación
xtreg lifeladder gdpwh_c gdpwh_c_sq lgbt_c gdpwh_lgbt_c social freedom peace unemployment inflation gini gender, fe vce(cluster code_num)

* Verificar multicolinealidad en modelo con variables centradas
* Esto debería mostrar valores VIF sustancialmente menores
reg lifeladder gdpwh_c gdpwh_c_sq lgbt_c gdpwh_lgbt_c social freedom peace unemployment inflation gini gender
estat vif

* Análisis por grupo de ingresos con el modelo principal integrado
levelsof ingresos, local(grupos)
foreach grupo in `grupos' {
    di "***********************************************************"
    di "Resultados para países de ingresos: `grupo'"
    di "***********************************************************"
    xtreg lifeladder gdpwh_c gdpwh_c_sq lgbt_c gdpwh_lgbt_c social freedom peace unemployment inflation gini gender if ingresos == `grupo', fe vce(cluster code_num)
}

********************************************************************************
** SECCIÓN 4: ANÁLISIS DE ROBUSTEZ                                            **
********************************************************************************
**# Bookmark #1

* Modelo con variables rezagadas para mitigar posible endogeneidad
* Al rezagar variables potencialmente endógenas, se reduce riesgo de causalidad inversa
sort code_num year
by code_num: gen lgbt_c_L1 = lgbt_c[_n-1] if year==year[_n-1]+1
by code_num: gen gdpwh_c_L1 = gdpwh_c[_n-1] if year==year[_n-1]+1
by code_num: gen gdpwh_c_L1_sq = gdpwh_c_L1^2
by code_num: gen gdpwh_lgbt_c_L1 = gdpwh_c_L1 * lgbt_c_L1

xtreg lifeladder gdpwh_c_L1 gdpwh_c_L1_sq lgbt_c_L1 gdpwh_lgbt_c_L1 social freedom peace unemployment inflation gini gender, fe vce(cluster code_num)

* Análisis de sensibilidad: Exclusión secuencial de controles
* Este análisis evalúa la estabilidad del coeficiente de interés
xtreg lifeladder gdpwh_c gdpwh_c_sq lgbt_c gdpwh_lgbt_c, fe vce(cluster code_num)
xtreg lifeladder gdpwh_c gdpwh_c_sq lgbt_c gdpwh_lgbt_c social freedom, fe vce(cluster code_num)
xtreg lifeladder gdpwh_c gdpwh_c_sq lgbt_c gdpwh_lgbt_c social freedom peace unemployment inflation, fe vce(cluster code_num)
xtreg lifeladder gdpwh_c gdpwh_c_sq lgbt_c gdpwh_lgbt_c social freedom peace unemployment inflation gini gender, fe vce(cluster code_num)

* Exportar resultados para diferentes usos (versión compatible con Stata básico)
estimates table fixed random, b(%9.3f) p

* Cerrar archivo de registro
log close

* Notificación de finalización
di "Análisis completado. Resultados guardados en directorio de trabajo."

********************************************************************************
**                                FIN DEL SCRIPT                              **
********************************************************************************