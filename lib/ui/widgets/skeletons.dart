part of com.watered_plants_ota_labs.app.widgets;

/// Skeletons de carga inicial (paquete `shimmer`). Reemplazan al
/// `CircularProgressIndicator` mientras llega la primera respuesta de
/// Firebase, imitando la forma de cada pantalla para que el contenido no
/// "salte" al aparecer. Cada skeleton usa un único [Shimmer] para toda la
/// pantalla. Esquinas rectas, como el resto del tema Blueprint.
class BlueprintShimmer extends StatelessWidget {
  const BlueprintShimmer({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) => Semantics(
    label: 'Cargando…',
    liveRegion: true,
    child: ExcludeSemantics(
      child: Shimmer.fromColors(
        baseColor: BlueprintColors.surfaceContainerLow,
        highlightColor: BlueprintColors.outlineVariant,
        child: child,
      ),
    ),
  );
}

/// Bloque rectangular de skeleton. El color real lo pinta el [Shimmer] que
/// lo envuelve; aquí solo tiene que ser opaco.
class SkeletonBox extends StatelessWidget {
  const SkeletonBox({super.key, this.width, this.height = 16});

  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: width,
    height: height,
    child: const ColoredBox(color: BlueprintColors.surfaceContainerLow),
  );
}

/// Home: calendario semanal, encabezado de sección, buscador y lista de
/// tarjetas con la forma de `BasicPlantCard`.
class PlantListSkeleton extends StatelessWidget {
  const PlantListSkeleton({super.key, this.itemCount = 5});

  final int itemCount;

  @override
  Widget build(BuildContext context) => BlueprintShimmer(
    child: SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const SkeletonBox(height: 96),
          const SizedBox(height: 24),
          const Row(
            children: <Widget>[
              SkeletonBox(width: 160, height: 14),
              Spacer(),
              SkeletonBox(width: 24, height: 24),
            ],
          ),
          const SizedBox(height: 16),
          const SkeletonBox(height: 48),
          const SizedBox(height: 16),
          for (int i = 0; i < itemCount; i++) const _SkeletonPlantCard(),
        ],
      ),
    ),
  );
}

class _SkeletonPlantCard extends StatelessWidget {
  const _SkeletonPlantCard();

  @override
  Widget build(BuildContext context) => Container(
    height: 78,
    margin: const EdgeInsets.only(bottom: 8),
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      border: Border.all(color: BlueprintColors.surfaceContainerLow),
    ),
    child: const Row(
      children: <Widget>[
        SkeletonBox(width: 52, height: 52),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              FractionallySizedBox(
                widthFactor: 0.6,
                child: SkeletonBox(height: 14),
              ),
              SizedBox(height: 8),
              FractionallySizedBox(
                widthFactor: 0.4,
                child: SkeletonBox(height: 10),
              ),
            ],
          ),
        ),
        SizedBox(width: 12),
        SkeletonBox(width: 64, height: 20),
      ],
    ),
  );
}
