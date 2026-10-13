package com.smartcity360.service;

import org.springframework.stereotype.Service;
import java.util.Map;

@Service
public class CityPulseService {

    private double weightResolution = 0.35;
    private double weightWaste = 0.25;
    private double weightAqi = 0.20;
    private double weightInfra = 0.20;

    public Map<String, Object> calculateCityPulse(
            long totalComplaints,
            long resolvedComplaints,
            long inProgressComplaints,
            double avgBinFillPct,
            double avgAqi,
            double avgLightUptimePct,
            long activeRoadComplaints) {

        double resolutionScore = totalComplaints > 0
                ? Math.min(100.0, ((resolvedComplaints * 1.0 + inProgressComplaints * 0.5) / totalComplaints) * 100.0)
                : 85.0;

        double wasteScore = Math.max(10.0, Math.min(100.0, 100.0 - avgBinFillPct));
        double aqiScore = Math.max(15.0, Math.min(100.0, 110.0 - (avgAqi * 0.55)));
        double infraScore = Math.max(20.0, Math.min(100.0, avgLightUptimePct - (activeRoadComplaints * 6.0)));

        double totalWeight = weightResolution + weightWaste + weightAqi + weightInfra;
        double finalScore = (weightResolution / totalWeight * resolutionScore)
                + (weightWaste / totalWeight * wasteScore)
                + (weightAqi / totalWeight * aqiScore)
                + (weightInfra / totalWeight * infraScore);

        int roundedScore = (int) Math.round(Math.max(0.0, Math.min(100.0, finalScore)));

        return Map.of(
            "score", roundedScore,
            "resolutionScore", resolutionScore,
            "wasteScore", wasteScore,
            "aqiScore", aqiScore,
            "infraScore", infraScore
        );
    }
}
