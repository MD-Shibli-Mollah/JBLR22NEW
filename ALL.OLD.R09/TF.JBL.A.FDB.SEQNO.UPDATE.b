SUBROUTINE TF.JBL.A.FDB.SEQNO.UPDATE
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------

*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
*Subroutine Description: FDB LN number generate ()
*Subroutine Type:
*Attached To    : DRAWINGS(DRAWINGS,JBL.F.EXPCOLL)
*Attached As    : AUTH ROUTINE   --DRAWINGS,JBL.F.EXPCOLL123
*-----------------------------------------------------------------------------
* Modification History :
* 15/08/2021 -                            Create   - Limon
*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $USING LC.Contract
    $USING EB.DataAccess
    $INCLUDE I_F.BD.F.LC.SERIAL.NUMBER
    $USING EB.LocalReferences

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
    FN.LC.SL.NO = 'F.BD.F.LC.SERIAL.NUMBER'
    F.LC.SL.NO = ''
    R.LC.SL.NO = ''

RETURN
*** </region>

*-----------------------------------------------------------------------------


*** <region name= OPENFILE>
OPENFILE:
*** <desc>FILE OPEN </desc>
    EB.DataAccess.Opf(FN.LC.SL.NO,F.LC.SL.NO)
RETURN
*** </region>

*** <region name= PROCESS>
PROCESS:
*** <desc>PROCESS BUSINESS LOGIC </desc>
    EB.LocalReferences.GetLocRef('DRAWINGS','LT.TF.ELC.COLNO',Y.FDB.NO.POS)
    
    Y.FDB.NO = EB.SystemTables.getRNew(LC.Contract.Drawings.TfDrLocalRef)<1,Y.FDB.NO.POS>
    Y.BRANCH.CODE = Y.FDB.NO[1,4]
    Y.YR.LC = Y.FDB.NO[9,2]
    Y.LC.CODE = Y.FDB.NO[5,4]
    Y.SEQ.NO = Y.FDB.NO[11,5]

    Y.LC.DATE = "20":Y.YR.LC
    Y.POS = 1 ; Y.POS.TYP = 1

    EB.DataAccess.FRead(FN.LC.SL.NO,Y.LC.DATE,R.LC.SL.NO,F.LC.SL.NO,LC.SL.ERR)

    IF R.LC.SL.NO THEN
        LOCATE Y.BRANCH.CODE IN R.LC.SL.NO<FD.SLNO.BRANCH.CODE,1> SETTING Y.POS THEN
            LOCATE Y.LC.CODE IN R.LC.SL.NO<FD.SLNO.LC.TYPE.CODE,Y.POS,1> SETTING Y.POS.TYP THEN
                R.LC.SL.NO<FD.SLNO.LC.SEQ.NO,Y.POS,Y.POS.TYP> = Y.SEQ.NO
            END ELSE
                R.LC.SL.NO<FD.SLNO.LC.TYPE.CODE,Y.POS,Y.POS.TYP> = Y.LC.CODE
                R.LC.SL.NO<FD.SLNO.LC.SEQ.NO,Y.POS,Y.POS.TYP> = Y.SEQ.NO
            END
        END ELSE
            R.LC.SL.NO<FD.SLNO.BRANCH.CODE,Y.POS>=Y.BRANCH.CODE
            R.LC.SL.NO<FD.SLNO.LC.TYPE.CODE,Y.POS,Y.POS.TYP>=Y.LC.CODE
            R.LC.SL.NO<FD.SLNO.LC.SEQ.NO,Y.POS,Y.POS.TYP>=Y.SEQ.NO
        END
    END ELSE
        R.LC.SL.NO<FD.SLNO.BRANCH.CODE,Y.POS>=Y.BRANCH.CODE
        R.LC.SL.NO<FD.SLNO.LC.TYPE.CODE,Y.POS,Y.POS.TYP>=Y.LC.CODE
        R.LC.SL.NO<FD.SLNO.LC.SEQ.NO,Y.POS,Y.POS.TYP>=Y.SEQ.NO
    END

    WRITE R.LC.SL.NO ON F.LC.SL.NO,Y.LC.DATE
RETURN

END
