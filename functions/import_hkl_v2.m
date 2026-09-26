function StructureFactors = import_hkl_v2(filename)

%% Read the reflection list written by SingleCrystal, one reflection per line:
% [   1]   -8  -3  -3   0.9488   1.02334e+01   0.00000e+00    0.000   1.02334e+01
% Lines are matched by pattern rather than by fixed column widths, because the
% reflection number widens the first column from [10000] on.
txt = fileread(filename);
tokens = regexp(txt, '\[\s*(\d+)\]\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)', 'tokens');
rawn = str2double(vertcat(tokens{:}));

%% Create output variable
StructureFactors = table;
StructureFactors.Number = (rawn(:, 1));
StructureFactors.h = (rawn(:, 2));
StructureFactors.k = (rawn(:, 3));
StructureFactors.l = (rawn(:, 4));
StructureFactors.d = (rawn(:, 5));
StructureFactors.FRe = (rawn(:, 6));
StructureFactors.FIm = (rawn(:, 7));
StructureFactors.Phase = (rawn(:, 8));
StructureFactors.F = (rawn(:, 9));

