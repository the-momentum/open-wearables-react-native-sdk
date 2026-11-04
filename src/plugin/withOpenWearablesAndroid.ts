import {
  ManifestActivity,
  ManifestActivityAlias,
} from "@expo/config-plugins/build/android/Manifest";
import { ConfigPlugin, withAndroidManifest } from "expo/config-plugins";

const withOpenWearablesAndroid: ConfigPlugin = (config) => {
  return withAndroidManifest(config, (config) => {
    const manifest = config.modResults.manifest;

    // MARK: - Health Connect aliases
    const application = manifest.application?.[0];
    if (!application) {
      return config;
    }

    const mainActivity = getMainActivityName(application.activity ?? []);

    const existingAliases = new Set(
      (application["activity-alias"] ?? []).map(
        (alias) => alias?.$?.["android:name"]
      )
    );

    const aliasesToAdd: ManifestActivityAlias[] = [];

    if (!existingAliases.has("ViewPermissionUsageActivity")) {
      aliasesToAdd.push({
        $: {
          "android:name": "ViewPermissionUsageActivity",
          "android:exported": "true",
          "android:targetActivity": mainActivity,
          "android:permission":
            "android.permission.START_VIEW_PERMISSION_USAGE",
        },
        "intent-filter": [
          {
            action: [
              {
                $: {
                  "android:name": "android.intent.action.VIEW_PERMISSION_USAGE",
                },
              },
            ],
            category: [
              {
                $: {
                  "android:name": "android.intent.category.HEALTH_PERMISSIONS",
                },
              },
            ],
          },
        ],
      });
    }

    if (!existingAliases.has("ShowPermissionRationaleActivity")) {
      aliasesToAdd.push({
        $: {
          "android:name": "ShowPermissionRationaleActivity",
          "android:exported": "true",
          "android:targetActivity": mainActivity,
        },
        "intent-filter": [
          {
            action: [
              {
                $: {
                  "android:name":
                    "androidx.health.ACTION_SHOW_PERMISSIONS_RATIONALE",
                },
              },
            ],
          },
        ],
      });
    }

    application["activity-alias"] = [
      ...(application["activity-alias"] ?? []),
      ...aliasesToAdd,
    ];

    return config;
  });
};

const getMainActivityName = (activities: ManifestActivity[]): string => {
  for (const activity of activities) {
    const intentFilters = activity["intent-filter"] ?? [];

    for (const filter of intentFilters) {
      const actions = filter.action ?? [];
      const categories = filter.category ?? [];

      const hasMainAction = actions.some(
        (a) => a?.$?.["android:name"] === "android.intent.action.MAIN"
      );

      const hasLauncherCategory = categories.some(
        (c) => c?.$?.["android:name"] === "android.intent.category.LAUNCHER"
      );

      if (hasMainAction && hasLauncherCategory) {
        return activity?.$?.["android:name"];
      }
    }
  }

  return ".MainActivity";
};

export default withOpenWearablesAndroid;
