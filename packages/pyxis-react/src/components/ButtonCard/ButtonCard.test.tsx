import { render, screen } from '@testing-library/react';
import { IconDownload } from 'components/Icon/Icons';
import ButtonCard from './ButtonCard';

describe('Button component', () => {
  describe('with default options', () => {
    test('should render', () => {
      render(<ButtonCard icon={IconDownload} id="default">Button title</ButtonCard>);
      const button = screen.getByTestId('default');
      const icon = button.querySelector('span.button-card__icon');
      const wrapper = button.querySelector('span.button-card__wrapper');
      const title = wrapper?.querySelector('span.button-card__title');
      expect(button).toBeInTheDocument();
      expect(button).toHaveTextContent('Button title');
      expect(button).toHaveAttribute('type', 'button');
      expect(button).toHaveAttribute('id', 'default');
      expect(icon).toBeInTheDocument();
      expect(wrapper).toBeInTheDocument();
      expect(title).toBeInTheDocument();
    });
  });

  describe('with options', () => {
    test('should render the icon', () => {
      render(<ButtonCard icon={IconDownload} id="with-icon">Button title</ButtonCard>);
      const button = screen.getByTestId('with-icon');
      const icon = button.querySelector('span.button-card__icon');
      const svg = icon?.querySelector('svg');
      expect(svg).toBeInTheDocument();
    });

    test('should have a subtitle', () => {
      render(<ButtonCard icon={IconDownload} id="with-subtitle" subtitle="Subtitle">Button title</ButtonCard>);
      const button = screen.getByTestId('with-subtitle');
      const subtitle = button.querySelector('span.button-card__wrapper span.button-card__subtitle');
      expect(subtitle).toBeInTheDocument();
      expect(subtitle).toHaveTextContent('Subtitle');
    });

    test('should be loading', () => {
      render(<ButtonCard icon={IconDownload} id="with-loading" loading subtitle="Subtitle">Button title</ButtonCard>);
      expect(screen.getByTestId('with-loading')).toHaveClass('button-card--loading');
      expect(screen.getByTestId('with-loading')).toHaveAttribute('tabIndex', '-1');
    });

    test('should have an alternative color', () => {
      render(<ButtonCard alt icon={IconDownload} id="with-alt" subtitle="Subtitle">Button title</ButtonCard>);
      expect(screen.getByTestId('with-alt')).toHaveClass('button-card--alt');
    });
  });
});
