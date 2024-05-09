#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:5.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build
WORKDIR /src
COPY ["Docker_Project/Docker_Project.csproj", "Docker_Project/"]
RUN dotnet restore "Docker_Project/Docker_Project.csproj"
COPY . .
WORKDIR "/src/Docker_Project"
RUN dotnet build "Docker_Project.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "Docker_Project.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "Docker_Project.dll"]