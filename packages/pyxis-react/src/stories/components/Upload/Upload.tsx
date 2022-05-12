import React from "react";
import styles from "./Upload.module.scss";
import {
  IconClose, IconLoader,
  IconLockerOpen,
  IconPaperclip,
  IconPlusCircle
} from "../../../components/Icon/Icons";
import Button from "../../../components/Button";

const Upload = () => {
  return (
    <div className={styles.wrapper}>
      <div className="form-item">
        <label className="form-label">
          Foto o altri documenti
        </label>
        <div className="form-item__wrapper">
          <div className="form-field form-field--upload">
            <label className="form-field__wrapper">
              <Button size="small" variant="ghost" icon={IconPlusCircle}>Carica file</Button>
              <span className="form-field--upload__description">&nbsp;oppure trascinalo qui</span>
            </label>

            <div className="form-upload-wrapper">

              <div className="form-upload__item-wrapper">
                <div className="form-upload__item form-upload__item--loading" style={{ "--loading-status": "80%" } as React.CSSProperties}>
                  <div className="form-upload__item__addon">
                    <div className="form-upload__item__addon__loading" />
                  </div>
                  <div className="form-upload__item__name">
                    IMG123452.jpg
                  </div>
                  <div className="form-upload__item__addon">
                    <button className="form-upload__item__addon__button" >
                      <IconClose size="s" description='Rimuovi file "nome file"'/>
                    </button>
                  </div>
                </div>
              </div>

              <div className="form-upload__item-wrapper">
                <div className="form-upload__item">
                  <div className="form-upload__item__addon">
                    <IconPaperclip size="s"/>
                  </div>
                  <div className="form-upload__item__name">
                    Modulo_CAI1Modulo_CAI1Modulo_CAI1Modulo_CAI1Modulo_CAI1Modulo_CAI1.jpg
                  </div>
                  <div className="form-upload__item__addon">
                    <button className="form-upload__item__addon__button">
                      <IconClose size="s" description='Rimuovi file "nome file"'/>
                    </button>
                  </div>
                </div>
              </div>

              <div className="form-upload__item-wrapper">
                <div className="form-upload__item form-upload__item--error">
                  <div className="form-upload__item__addon">
                    <IconPaperclip size="s"/>
                  </div>
                  <div className="form-upload__item__name">
                    Modulo_CAI1-Modulo_CAI1 Modulo_CAI1 Modulo_CAI1 Modulo_CAI1.pdf
                  </div>
                  <div className="form-upload__item__addon">
                    <button className="form-upload__item__addon__button">
                      <IconLockerOpen size="s" description='Ricarica file "nome file"' aria-describedby="errorMessageFile"/>
                    </button>
                    <button className="form-upload__item__addon__button">
                      <IconClose size="s" description='Rimuovi file "nome file"'/>
                    </button>
                  </div>
                </div>
                <div className="form-upload__item-error-message" id="errorMessageFile">
                  Error Message
                </div>
              </div>

            </div>
          </div>
          <div className="form-item__error-message">
            Error Message
          </div>
        </div>
      </div>
    </div>
  )
}

export default Upload;
