SUBROUTINE TF.JBL.A.LC.SEQNO.UPDATE
*-----------------------------------------------------------------------------
*Subroutine Description: Old LC serial number update routine
*Subroutine Type:
*Attached To    : LC Version (LC,JBL.IMPSIGHT ; LC,JBL.IMPUSANCE, LETTER.OF.CREDIT,JBL.BTBSIGHT, LETTER.OF.CREDIT,JBL.BTBUSANCE , LETTER.OF.CREDIT,JBL.EDFOPEN)
*Attached As    : AUTH ROUTINE
*-----------------------------------------------------------------------------
* Modification History :
* 23/10/2019 -                            Retrofit   - MD. EBRAHIM KHALIL RIAN,
*                                                 FDS Bangladesh Limited
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $USING LC.Contract
    $USING EB.DataAccess
    $INCLUDE I_F.BD.LC.SERIAL.NUMBER

    $USING EB.SystemTables
*-----------------------------------------------------------------------------
    IF EB.SystemTables.getVFunction() NE 'A' THEN RETURN
*-----------------------------------------------------------------------------
    
    GOSUB INITIALISE ; *INITIALISATION
    GOSUB OPENFILE ; *FILE OPEN
    GOSUB PROCESS ; *PROCESS BUSINESS LOGIC
RETURN
*-----------------------------------------------------------------------------

*** <region name= INITIALISE>
INITIALISE:
*** <desc>INITIALISATION </desc>
    FN.LC.SL.NO = 'F.BD.LC.SERIAL.NUMBER'
    F.LC.SL.NO = ''
    R.LC.SL.NO = ''

RETURN
*** </region>

*** <region name= OPENFILE>
OPENFILE:
*** <desc>FILE OPEN </desc>
    EB.DataAccess.Opf(FN.LC.SL.NO,F.LC.SL.NO)
RETURN
*** </region>

*** <region name= PROCESS>
PROCESS:
*** <desc>PROCESS BUSINESS LOGIC </desc>
    Y.OLDLC.NO = EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcOldLcNumber)
    Y.BRANCH.CODE = Y.OLDLC.NO[1,4]
    Y.YR.LC = Y.OLDLC.NO[5,2]
    Y.LC.CODE = Y.OLDLC.NO[7,2]
********************** erian@fortress-global.com*********20201024******************
    IF Y.LC.CODE EQ '03' OR Y.LC.CODE EQ '04' THEN
        Y.SEQ.NO = Y.OLDLC.NO[9,5]
    END ELSE
        Y.SEQ.NO = Y.OLDLC.NO[9,4]
    END
*********END************* erian@fortress-global.com*********20201024******************
    Y.NEW.SEQ.NO = ''
    Y.LC.DATE = EB.SystemTables.getToday()[1,4]
    Y.POS = 1 ; Y.POS.TYP = 1

    EB.DataAccess.FRead(FN.LC.SL.NO,Y.LC.DATE,R.LC.SL.NO,F.LC.SL.NO,LC.SL.ERR)
    
    IF R.LC.SL.NO THEN
        LOCATE Y.BRANCH.CODE IN R.LC.SL.NO<LC.SLNO.BRANCH.CODE,1> SETTING Y.POS THEN
            LOCATE Y.LC.CODE IN R.LC.SL.NO<LC.SLNO.LC.TYPE.CODE,Y.POS,1> SETTING Y.POS.TYP THEN
                R.LC.SL.NO<LC.SLNO.LC.SEQ.NO,Y.POS,Y.POS.TYP> = Y.SEQ.NO
            END ELSE
                R.LC.SL.NO<LC.SLNO.LC.SEQ.NO,Y.POS,Y.POS.TYP> = Y.SEQ.NO
                R.LC.SL.NO<LC.SLNO.LC.TYPE.CODE,Y.POS,Y.POS.TYP> = Y.LC.CODE
            END
        END ELSE
            R.LC.SL.NO<LC.SLNO.BRANCH.CODE,Y.POS> = Y.BRANCH.CODE
            R.LC.SL.NO<LC.SLNO.LC.TYPE.CODE,Y.POS,Y.POS.TYP> = Y.LC.CODE
            R.LC.SL.NO<LC.SLNO.LC.SEQ.NO,Y.POS,Y.POS.TYP> = Y.SEQ.NO
        END
    END ELSE
        R.LC.SL.NO<LC.SLNO.BRANCH.CODE,Y.POS> = Y.BRANCH.CODE
        R.LC.SL.NO<LC.SLNO.LC.TYPE.CODE,Y.POS,Y.POS.TYP> = Y.LC.CODE
        R.LC.SL.NO<LC.SLNO.LC.SEQ.NO,Y.POS,Y.POS.TYP> = Y.SEQ.NO
    END

    WRITE R.LC.SL.NO ON F.LC.SL.NO,Y.LC.DATE
RETURN
*** </region>
END
