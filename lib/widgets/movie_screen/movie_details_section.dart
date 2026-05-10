import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:movietrackr/widgets/shared/section_separator.dart';

import '../../app_theme.dart';
import '../../models/production_company.dart';

class MovieDetails extends StatelessWidget{
  final int budget;
  final int revenue;
  final String status;
  final DateTime release_date;
  final List<String>production_companies;
  final List<ProductionCountry>production_countries;

  const MovieDetails({
    super.key,
    required this.budget,
    required this.revenue,
    required this.status,
    required this.release_date,
    required this.production_companies,
    required this.production_countries,
  });

  @override
  Widget build(BuildContext context) {
    final DateFormat dateFormatter = DateFormat('dd.MM.yyyy');
    final moneyFormatter = NumberFormat.decimalPattern('en_US')
      ..minimumFractionDigits = 2  ..maximumFractionDigits = 2;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Details",
          style: AppTheme.h3SemiboldOnMediumBlue,
        ),

        SectionSeparator(),

        if(production_companies.isNotEmpty)...[
          Text(
            "Studios",
            style: AppTheme.h4SemiboldOnMediumBlue,
          ),

          const SizedBox(height: AppTheme.xs),

          Wrap(
            spacing: AppTheme.sm,
            runSpacing: AppTheme.sm,
            children: production_companies.map((company) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.sm,
                  vertical: AppTheme.xs,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.deepBlue.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(AppTheme.xs),
                ),
                child: Text(company, style: AppTheme.h6SemiboldOnMediumBlue),
              );
            }).toList(),
          ),

          const SizedBox(height: AppTheme.md),
        ],

        if(production_countries.isNotEmpty)...[
          Text(
            production_countries.length > 1
                ? "Countries"
                : "Country",
            style: AppTheme.h4SemiboldOnMediumBlue,
          ),

          const SizedBox(height: AppTheme.xs),

          Wrap(
            spacing: AppTheme.sm,
            runSpacing: AppTheme.sm,
            children: production_countries.map((country) {
              return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppTheme.sm,
                    vertical: AppTheme.xs,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.deepBlue.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(AppTheme.xs),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        country.name,
                        style: AppTheme.h6SemiboldOnMediumBlue,
                      ),

                      const SizedBox(width: AppTheme.sm),

                      CountryFlag.fromCountryCode(
                        country.iso_3166_1,
                        theme: const ImageTheme(
                            shape: Circle(),
                            height: AppTheme.md,
                            width: AppTheme.md
                        ),
                      )
                    ],
                  )
              );
            }).toList(),
          ),

          const SizedBox(height: AppTheme.md),
        ],

        Row(
          children: [
            Text(
              "Release date:\t${dateFormatter.format(release_date)}".replaceAll('\t', '    '),
              style: AppTheme.h5SemiboldOnMediumBlue,
            ),

            const SizedBox(width: AppTheme.sm),

            Icon(
              Icons.calendar_month_outlined,
              size: AppTheme.md,
              color: AppTheme.textOnMediumBlue,
            ),
          ],
        ),

        const SizedBox(height: AppTheme.sm),

        Row(
          children: [
            Text(
              "Status:",
              style: AppTheme.h5SemiboldOnMediumBlue,
            ),

            const SizedBox(width: AppTheme.sm),

            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppTheme.sm,
                vertical: AppTheme.xs,
              ),
              decoration: BoxDecoration(
                color: AppTheme.deepBlue.withOpacity(0.6),
                borderRadius: BorderRadius.circular(AppTheme.xs),
              ),
              child: Text(
                status,
                style: () {
                  switch (status) {
                    case 'Released':
                      return AppTheme.h6SemiboldPrimaryGreen;
                    case 'Post Production':
                    case 'In Production':
                      return AppTheme.h6SemiboldPrimaryYellow;
                    case 'Canceled':
                    case 'Rumored':
                      return AppTheme.h6SemiboldPrimaryRed;
                  }
                }(),
              ),
            ),
          ],
        ),

        const SizedBox(height: AppTheme.sm),

        Text(
          "Budget:\t${moneyFormatter.format(budget)} USD".replaceAll('\t', '    '),
          style: AppTheme.h5SemiboldOnMediumBlue,
        ),

        const SizedBox(height: AppTheme.sm),

        Text(
          "Revenue:\t${moneyFormatter.format(revenue)} USD".replaceAll('\t', '    '),
          style: AppTheme.h5SemiboldOnMediumBlue,
        ),

        const SizedBox(height: AppTheme.sm),

        Text(
          "Links:",
          style: AppTheme.h5SemiboldOnMediumBlue,
        ),

        const SizedBox(height: AppTheme.xs),
      ],
    );
  }
}