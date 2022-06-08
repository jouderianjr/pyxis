import {
  render, screen, fireEvent, within,
} from '@testing-library/react';
import Modal from './Modal';

describe('Modal component', () => {
  test('is visible when isOpen', () => {
    render(
      <Modal id="testModal" isOpen>
        <Modal.Header />
        <Modal.Content />
        <Modal.Footer />
      </Modal>,
    );
    const modal = screen.getByRole('dialog');
    expect(modal).toBeInTheDocument();
  });
  test('is hidden when isOpen is false', () => {
    render(
      <Modal id="testModal" isOpen={false}>
        <Modal.Header />
        <Modal.Content />
        <Modal.Footer />
      </Modal>,
    );
    const modal = screen.queryByRole('dialog');
    expect(modal).not.toBeInTheDocument();
  });
  test('has aria description when passed', () => {
    render(
      <Modal
        accessibilityDescription="Test accessibility description"
        id="testModal"
        isOpen
      >
        <Modal.Header />
        <Modal.Content />
        <Modal.Footer />
      </Modal>,
    );
    const modal = screen.queryByRole('dialog');
    expect(modal).toHaveAccessibleDescription('Test accessibility description');
  });
  test('can be centered', () => {
    render(
      <Modal id="testModal" isCentered isOpen>
        <Modal.Header />
        <Modal.Content />
        <Modal.Footer />
      </Modal>,
    );
    const modalPanel = screen.getByTestId('testModal');
    expect(modalPanel).toHaveClass('modal--center');
  });
  test('can have custom class', () => {
    render(
      <Modal className="custom-class" id="testModal" isOpen>
        <Modal.Header />
        <Modal.Content />
        <Modal.Footer />
      </Modal>,
    );
    const modal = screen.getByRole('dialog');
    expect(modal).toHaveClass('custom-class');
  });
  test('calls onClose callback on close click', () => {
    const onCloseCb = jest.fn();
    render(
      <Modal id="testModal" isOpen onClose={onCloseCb}>
        <Modal.Header />
        <Modal.Content />
        <Modal.Footer />
      </Modal>,
    );
    fireEvent.click(screen.getByTestId('testModal-backdrop-close-button'));
    expect(onCloseCb).toHaveBeenCalled();
  });
  describe('size options', () => {
    test('can be large', () => {
      render(
        <Modal id="testModal" isOpen size="large">
          <Modal.Header />
          <Modal.Content />
          <Modal.Footer />
        </Modal>,
      );
      const modalPanel = screen.getByTestId('testModal');
      expect(modalPanel).toHaveClass('modal--large');
    });
    test('can be medium', () => {
      render(
        <Modal id="testModal" isOpen size="medium">
          <Modal.Header />
          <Modal.Content />
          <Modal.Footer />
        </Modal>,
      );
      const modalPanel = screen.getByTestId('testModal');
      expect(modalPanel).toHaveClass('modal--medium');
    });
    test('can be small', () => {
      render(
        <Modal id="testModal" isOpen size="small">
          <Modal.Header />
          <Modal.Content />
          <Modal.Footer />
        </Modal>,
      );
      const modalPanel = screen.getByTestId('testModal');
      expect(modalPanel).toHaveClass('modal--small');
    });
    test('defaults to medium', () => {
      render(
        <Modal id="testModal" isOpen>
          <Modal.Header />
          <Modal.Content />
          <Modal.Footer />
        </Modal>,
      );
      const modalPanel = screen.getByTestId('testModal');
      expect(modalPanel).toHaveClass('modal--medium');
    });
  });
  describe('child content', () => {
    test('should render in correct order', () => {
      render(
        <Modal id="testModal" isOpen>
          <Modal.Content>Some Content</Modal.Content>
          <Modal.Footer />
          <Modal.Header />
        </Modal>,
      );
      const modalPanel = screen.getByTestId('testModal');
      const [header, content, footer] = modalPanel.children;
      expect(header).toBe(screen.getByRole('banner'));
      expect(footer).toBe(screen.getByRole('contentinfo'));
      expect(content).toHaveTextContent('Some Content');
    });
    test('is labeled by its Header component', () => {
      render(
        <Modal id="testModal" isOpen>
          <Modal.Header title="Test Modal" />
          <Modal.Content />
          <Modal.Footer />
        </Modal>,
      );
      expect(screen.getByLabelText('Test Modal')).toBe(
        screen.getByRole('dialog'),
      );
    });
    test('forwards its onClose to the Header component', () => {
      const onCloseCb = jest.fn();
      render(
        <Modal id="testModal" isOpen onClose={onCloseCb}>
          <Modal.Header title="Test Modal" />
          <Modal.Content />
          <Modal.Footer />
        </Modal>,
      );
      const header = screen.getByRole('banner');
      fireEvent.click(within(header).getByLabelText('close'));
      expect(onCloseCb).toHaveBeenCalled();
    });
  });
});
