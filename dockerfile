FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 80

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src

COPY ["hello-world-api/hello-world-api.csproj", "./"]
RUN dotnet restore "hello-world-api.csproj"

COPY . . 
WORKDIR "/src/."
RUN dotnet build "hello-world-api.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "hello-world-api.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "hello-world-api.dll"]
