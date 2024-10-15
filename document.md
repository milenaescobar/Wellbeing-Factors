## Research Plan: Socioeconomic Determinants of Global Happiness 

## 1. Problem Statement 
Subjective well-being, commonly referred to as happiness, has garnered increasing attention in recent 
years as a critical factor in understanding human welfare. Traditional economic indicators, such as GDP 
per capita, have long been used as proxies for societal well-being. However, emerging research shows that 
focusing exclusively on economic growth overlooks significant non-economic determinants of happiness, 
such as social inclusion, personal freedoms, and the quality of health and education systems (Nikolova & 
Graham, 2020). Understanding the full range of factors that contribute to happiness is essential for 
creating holistic policies aimed at improving the quality of life, especially in the context of economic 
development and income inequality. 
Happiness has been shown to correlate with a variety of socioeconomic factors, including unemployment, 
inflation, and peace (Wong et al., 2023). Additionally, more recent studies highlight the growing role of 
social acceptance—particularly of marginalized groups like the LGBT community—in contributing to a 
society’s overall happiness (Ligonenko, Borysov, & Gritsyak, 2023). This study seeks to explore how 
both economic and social factors interact to affect happiness across countries with different income levels, 
focusing on key variables such as GDP per capita, LGBT acceptance, peace, unemployment, gender 
inequality, and social support. 

Research Problem: While it is well-documented that GDP per capita and unemployment rates influence 
happiness, the role of social variables, such as LGBT acceptance and peace, remains less understood, 
especially in the context of different income levels. For instance, does economic growth lead to greater 
happiness in countries with lower LGBT acceptance? How do peace and unemployment rates interact in 
determining life satisfaction in lower-income countries compared to wealthier nations? This study aims to 
address these questions, providing a more nuanced understanding of how both economic and social 
factors contribute to happiness across various income levels. 

Previous studies suggest that while economic growth improves life satisfaction to some extent, non
economic factors like peace, social support, and the protection of personal freedoms play an increasingly 
significant role as countries develop economically (Nikolova & Graham, 2020). As such, this study will 
fill a gap in the literature by incorporating these non-economic variables and exploring their interaction 
with traditional economic indicators. 

## 2. Research Methodology 
Quantitative Empirical Model: The research employs panel data covering 123 countries from 2008 to 
2019 to examine the relationship between economic and social factors and happiness. The use of panel 
data is crucial for this study as it allows us to observe both between-country differences and within
country changes over time. This longitudinal approach provides a richer understanding of how factors like 
LGBT acceptance, unemployment, peace, and GDP per capita affect happiness within countries over 
time, controlling for unobservable factors that may vary across countries but remain constant within each 
country (Nikolova & Graham, 2020). 
The empirical strategy relies on a fixed-effects (FE) model, which is particularly well-suited for this type 
of analysis because it controls for unobserved heterogeneity. Specifically, this model adjusts for factors 
that are unique to each country but do not change over time, such as cultural traits or long-standing social 
norms. By doing so, the fixed-effects model isolates the effects of changes in variables like GDP, 
unemployment, and social inclusion on happiness within each country. 
The fixed-effects regression model used is as follows: 
xtreg lifeladder lgbt peace unemployment gender c.gdpwh##c.social, vce(cluster code_num) fe 
 
In this model, the dependent variable is the happiness score, measured by the Life Ladder index, which 
captures self-reported life satisfaction. The key independent variables include: 
• GDP per capita (log): A standard measure of economic well-being. 
• LGBT acceptance index: A measure of societal attitudes toward LGBT communities, which 
reflects social inclusivity. 
                                                                                  
             rho    .81628371   (fraction of variance due to u_i)
         sigma_e    .33661559
         sigma_u    .70954665
                                                                                  
           _cons    -5.159173   3.430062    -1.50   0.135    -11.94932    1.630977
                  
c.gdpwh#c.social    -.2398703   .2395986    -1.00   0.319    -.7141796     .234439
                  
          social     3.099917   2.293437     1.35   0.179    -1.440171    7.640004
           gdpwh      .995324      .3446     2.89   0.005     .3131539    1.677494
          gender     2.682126   .8359117     3.21   0.002     1.027355    4.336897
    unemployment    -.0580631   .0095706    -6.07   0.000     -.077009   -.0391172
           peace     .0000611   .0000452     1.35   0.179    -.0000283    .0001505
            lgbt     .0114976   .0208429     0.55   0.582     -.029763    .0527582
                                                                                  
      lifeladder   Coefficient  std. err.      t    P>|t|     [95% conf. interval]
                                 Robust
                                                                                  
                                 (Std. err. adjusted for 123 clusters in code_num)
 corr(u_i, Xb) = 0.3445                          Prob > F          =     0.0000
                                                F(7,122)          =      14.20
     Overall = 0.5789                                         max =         12
     Between = 0.5964                                         avg =        9.0
     Within  = 0.1622                                         min =          1
 R-squared:                                      Obs per group:
 Group variable: code_num                        Number of groups  =        123
 Fixed-effects (within) regression               Number of obs     =      1,106
 > ) fe  
. xtreg lifeladder lgbt  peace unemployment gender c.gdpwh##c.social, vce(cluster code_num
 . do "C:\Users\m_ile\AppData\Local\Temp\STD2058_000000.tmp"
• Peace index: Captures the level of peace within a country, which can impact personal safety and 
social stability. 
• Unemployment rate: An indicator of economic distress. 
• Gender inequality index: A measure of the gap in opportunities and rights between men and 
women. 
• Social support: Reflects the level of support individuals perceive they have from their 
community, family, and government. 
The interaction term between GDP per capita and social support is included to test whether the positive 
effects of economic growth on happiness are enhanced or diminished by the level of social support within 
a country. 
Data Sources: 
• World Happiness Report: Provides the Life Ladder index, a key measure of subjective well-being 
across countries. 
• World Bank and IMF: Sources for economic indicators such as GDP per capita, unemployment, 
and inflation (Nikolova & Graham, 2020). 
• Global Peace Index: Measures internal peace and stability within countries. 
• Gallup World Poll: Provides data on social support and LGBT acceptance (Wong et al., 2023). 
The dataset includes variables covering a broad range of socioeconomic and social factors, allowing for a 
comprehensive analysis of the determinants of happiness. By combining both economic and non
economic variables, the study provides a more holistic understanding of what drives well-being. 
Descriptive Statistics: A summary of the key variables shows substantial variability, which is essential 
for conducting robust regression analysis: 
• Happiness (Life Ladder): Mean = 5.56, SD = 1.16, Min = 2.66, Max = 7.97. 
• GDP per capita (log): Mean = 9.49, SD = 1.16, Min = 6.61, Max = 11.66. 
• LGBT acceptance: Mean = 3.43, SD = 3.95, Min = -3.48, Max = 13. 
• Peace index: Mean = 1856.75, SD = 598.46, Min = -1000, Max = 3386.
>
## 3. Interpretation of Coefficients 
The interpretation of the coefficients provides insights into how each independent variable affects 
happiness. The key findings from the regression model are as follows: 

1. LGBT Acceptance (lgbt): The coefficient for LGBT acceptance is positive (0.011), suggesting 
that higher levels of LGBT acceptance are associated with higher happiness levels. However, the 
p-value (0.582) indicates that this relationship is not statistically significant, implying that, in this 
sample, we cannot confidently assert that LGBT acceptance directly affects happiness. Although 
previous literature suggests that inclusive policies promote well-being (Ligonenko et al., 2023), 
more data might be needed to confirm this relationship across countries with varying levels of 
social acceptance.

3. Peace Index (peace): The coefficient for peace is 0.00006, implying a positive but very small 
association with happiness. However, this relationship is not statistically significant (p = 0.179). 
This suggests that while more peaceful countries may tend to report slightly higher happiness 
levels, the evidence from this sample does not strongly support this effect.
 
4. Unemployment (unemployment): The coefficient for unemployment is negative (-0.058), 
indicating that higher unemployment rates are associated with lower levels of happiness. This 
result is highly significant (p < 0.001), reinforcing findings from existing literature that economic 
distress caused by unemployment has a strong negative impact on subjective well-being (Wong et 
al., 2023).

5. Gender Inequality (gender): The coefficient for the gender inequality index is 2.68, showing 
that greater gender equality is strongly associated with higher happiness levels. The result is 
statistically significant (p = 0.002), suggesting that policies promoting gender equality can lead to 
substantial improvements in overall life satisfaction.

6. GDP per capita (gdpwh): The GDP per capita coefficient is positive (0.995) and statistically 
significant (p = 0.005). This indicates that wealthier countries report higher happiness levels, 
consistent with established economic theories linking prosperity to well-being.

7. Social Support (social): The coefficient for social support is positive (3.10), but not statistically 
significant (p = 0.179). While social support is often regarded as a key determinant of happiness, 
in this model, the effect is not strong enough to be confirmed with statistical confidence.

8. Interaction between GDP per capita and Social Support (c.gdpwh#c.social): The interaction 
term between GDP and social support is negative (-0.239) but not statistically significant (p = 
0.319). This suggests that the combined effect of GDP per capita and social support on happiness 
is complex and may require further research to understand how these variables interact under 
different condition

## 4. Justification of the Research Importance 
Academic Relevance: This study contributes to the growing body of literature on the economics of 
happiness by integrating both economic and social variables into the analysis of life satisfaction. 
Traditionally, economists have focused on income and employment as primary determinants of well
being, but recent research suggests that social factors—such as social acceptance, peace, and community 
support—are equally important in shaping happiness (Nikolova & Graham, 2020). By employing panel 
data and a fixed-effects model, this study offers a nuanced view of how these variables interact over time 
and across countries, providing new insights into the drivers of happiness in both developed and 
developing nations. 
For example, studies have shown that in high-income countries, the marginal utility of additional income 
diminishes as basic needs are met, making factors like personal freedoms and social inclusion more 
critical in determining happiness (Wong et al., 2023). This research will provide further evidence of this 
trend, highlighting the role of non-economic factors in improving well-being, particularly in societies that 
are economically prosperous, but face challenges related to social cohesion. 
Policy Implications: Understanding the determinants of happiness has significant implications for public 
policy. Governments worldwide are increasingly focusing on measures of well-being beyond GDP to 
assess progress. This study provides empirical evidence that could inform policy design in both high- and 
low-income countries. For instance, the inclusion of LGBT acceptance and peace as critical factors 
suggests that policies aimed at fostering social inclusivity and reducing conflict could have a substantial 
impact on national happiness, even in countries with lower economic growth (Ligonenko et al., 2023). 
Moreover, the interaction between GDP and social support in the model can inform policymakers about 
the conditions under which economic growth translates most effectively into improvements in happiness. 
If strong social support systems enhance the benefits of economic growth, countries may need to invest in 
building community networks and support mechanisms to maximize the impact of their economic policies 
on well-being (Nikolova & Graham, 2020). 
Contribution to the Global Happiness Agenda: This research also contributes to the broader agenda of 
global well-being, which is increasingly becoming a focal point for international organizations such as the 
United Nations. In line with the UN's Sustainable Development Goals (SDGs), this study highlights the 
importance of inclusive growth and peace in improving well-being. Findings from this study could guide 
policymakers in aligning their development strategies with the SDGs, particularly in areas like reducing 
inequality (SDG 10) and promoting peaceful and inclusive societies (SDG 16). 

References :
• Ligonenko, L., Borysov, Y., & Gritsyak, L. (2023). Predictors of Happiness: Regression Modeling 
as a Basis for Determining the Necessary Actions and Decisions. Kyiv National University of 
Economics. 
• Nikolova, M., & Graham, C. (2020). The Economics of Happiness. GLO Discussion Paper No. 
640. https://hdl.handle.net/10419/223227 
• Wong, P. T. P., Ho, L. S., Mayer, C.-H., Yang, F., & Cowden, R. G. (2023). A New Science of 
Suffering and the New Behavioral Economics of Happiness: Toward a General Theory of Well
being. Frontiers in Psychology, 14, Article 1280613. https://doi.org/10.3389/fpsyg.2023.1280613 
• Zilli, J. B., & Guazzelli, G. P. (2016). Economics of Happiness: A Study on Happiness Indicators 
in University Professors. Ecoforum, 5(1), 171–180.
