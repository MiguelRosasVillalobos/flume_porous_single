using CSV
using DataFrames
using Plots

# Ruta al archivo CSV
archivo_csv = "./freesurface.csv"

# Leer el archivo CSV
datos = CSV.read(archivo_csv,DataFrame, delim=',')

# Crear una función para generar un gráfico para una fila específica
function grafico_fila(fila)
    longitud = length(fila)
    discretizacion = 0:8/(longitud - 1):8
    plot(discretizacion, fila,
         xlabel="Discretización",
         ylabel="Valor de la fila (truncado)",
         label="Datos", 
         legend=:topright,
        ylims=(0.29, 0.30),
        markercolor = :blue,
        markershape = :circle,
        markersize = 0.1,
        )
end

# Crear una animación con cada fila de datos
animacion = @animate for i in 1:size(datos, 1)
    fila_redondeada = round.(collect(datos[i, :]), digits=2)
    grafico = grafico_fila(fila_redondeada)
    plot(grafico, title="Fila $i")
end

# Guardar la animación en un archivo GIF
gif(animacion, "animacion.gif", fps = 10)

