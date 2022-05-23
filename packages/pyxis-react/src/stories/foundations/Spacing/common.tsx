import { Spacing as SpacingShape } from './Spacing';
import spacingTokens from '@pyxis/tokens/json/spacings.json';

export const generateTestComponentMeta: GenerateAllStoriesComponentMeta<typeof SpacingShape> = () => ({
  title: 'Test/Spacing',
  component: SpacingShape,
});

export const spacings:SpacingRow[] = Object.entries(spacingTokens).flatMap(([size, value]) => ({
  size: size as Spacing,
  value: value,
}));

export interface SpacingRow {
  size: Spacing;
  value: number;
}
