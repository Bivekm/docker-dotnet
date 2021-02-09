FROM mcr.microsoft.com/dotnet/core/aspnet:3.1-buster-slim AS base
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/core/sdk:3.1-buster AS build
WORKDIR /src
COPY *.csproj ./
RUN dotnet restore
COPY . ./
RUN dotnet build -c Release

FROM build AS publish
RUN dotnet publish -c Release

FROM base AS final
WORKDIR /app
COPY --from=publish /src/bin/Release/netcoreapp3.1/publish .
ENTRYPOINT ["dotnet", "dockerDotnet.dll"]
