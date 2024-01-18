SUBROUTINE TF.JBL.I.IDB.IDBLN.NUM
    !PROGRAM TF.JBL.I.IDB.IDBLN.NUM
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------

*-----------------------------------------------------------------------------
*Subroutine Description: IDBP LN number generate ()
*Subroutine Type:
*Attached To    : DRAWINGS(DRAWINGS,JBL.I.EXPCOLL)
*Attached As    : INPUT ROUTINE   --DRAWINGS,JBL.I.EXPCOLL
*-----------------------------------------------------------------------------
* Modification History :
* 23/10/2019 -                            Retrofit   -
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INCLUDE I_F.BD.F.DR.SERIAL.NUMBER
    $INCLUDE I_F.BD.LC.AD.CODE
    
    $USING LC.Contract
    $USING EB.ErrorProcessing
    $USING EB.DataAccess
    $USING EB.SystemTables
    $USING EB.LocalReferences
    $USING EB.Foundation
  
    $USING EB.Reports
    $USING ST.CompanyCreation
    $USING ST.Customer
    $USING EB.Updates

*-----------------------------------------------------------------------------
    EB.Foundation.MapLocalFields('DRAWINGS', 'LT.TF.ELC.COLNO', Y.COL.NO.POS)
    Y.COL.NO = EB.SystemTables.getRNew(LC.Contract.Drawings.TfDrLocalRef)<1,Y.COL.NO.POS>
    IF Y.COL.NO THEN RETURN
*-----------------------------------------------------------------------------

    GOSUB INITIALISE ; *INITIALISATION
    GOSUB OPENFILE ; *FILE OPEN
    GOSUB PROCESS ; *PROCESS BUSINESS LOGIC
RETURN

*** <region name= INITIALISE>
INITIALISE:
*** <desc>INITIALISATION </desc>
    FN.LC = 'F.LETTER.OF.CREDIT'
    F.LC= ''
    
    FN.LC.SL.NO = 'F.BD.F.DR.SERIAL.NUMBER'
    F.LC.SL.NO = ''
    
    FN.AD.CODE = 'F.BD.LC.AD.CODE'
    F.AD.CODE = ''
    ! DEBUG
    ST.CompanyCreation.LoadCompany('BNK')
    EB.LocalReferences.GetLocRef('DRAWINGS','LT.TF.DOC.TYPE',Y.IDB.NO.POS)
    Y.AD.ID = EB.SystemTables.getIdCompany()
    !Y.AD.ID = 'BD0010133'
RETURN



*** <region name= OPENFILE>
OPENFILE:
*** <desc>FILE OPEN </desc>
    EB.DataAccess.Opf(FN.LC,F.LC)
    EB.DataAccess.Opf(FN.LC.SL.NO,F.LC.SL.NO)
    EB.DataAccess.Opf(FN.AD.CODE,F.AD.CODE)
RETURN
*** </region>

*** <region name= PROCESS>
PROCESS:
*** <desc>PROCESS BUSINESS LOGIC </desc>
    DEBUG
    EB.DataAccess.FRead(FN.AD.CODE,Y.AD.ID,R.AD.CODE,F.AD.CODE,AD.ERR)
    IF R.AD.CODE THEN
        Y.BRANCH.CODE = R.AD.CODE<AD.CODE.AD.CODE>
       
        IF Y.BRANCH.CODE ELSE
            EB.SystemTables.setEtext('Branch Code Missing for LC Type')
            EB.ErrorProcessing.StoreEndError()
        END
    END ELSE
        EB.SystemTables.setEtext('Company Not Defined in DEALERS Code')
        EB.ErrorProcessing.StoreEndError()
    END

    Y.FD.ID =EB.SystemTables.getRNew(LC.Contract.Drawings.TfDrLocalRef)<1,Y.IDB.NO.POS>
    Y.LC.CODE = ""
    IF( Y.FD.ID[1,1] EQ 'P') THEN
        Y.LC.CODE = 'IDBP'
    END
    ELSE
        Y.LC.CODE = 'IDBC'
    END
    ! Y.BRANCH.CODE = '1760'
    !  Y.YR.LC = "22"
    !  Y.LC.CODE = "IDBP"
    ! Y.SEQ.NO = "00001"
    Y.YR.LC = EB.SystemTables.getToday()[3,2]
    LC.SL.NO.ID = EB.SystemTables.getToday()[1,4]
    Y.SEQ.NO = '00001'
 
    EB.DataAccess.FRead(FN.LC.SL.NO, LC.SL.NO.ID, R.LC.SL.NO, F.LC.SL.NO, LC.SL.ERR)
    IF R.LC.SL.NO THEN
        LOCATE Y.BRANCH.CODE IN R.LC.SL.NO<ID.SLNO.BRANCH.CODE,1> SETTING Y.POS THEN
            LOCATE Y.LC.CODE IN R.LC.SL.NO<ID.SLNO.LC.TYPE.CODE,Y.POS,1> SETTING Y.POS.TYP THEN
                Y.SEQ.NO = R.LC.SL.NO<ID.SLNO.LC.SEQ.NO,Y.POS,Y.POS.TYP> + 1
                Y.SEQ.NO = FMT(Y.SEQ.NO,'R%5')
            END
        END
        Y.IDB.ID = Y.BRANCH.CODE:Y.LC.CODE:Y.YR.LC:Y.SEQ.NO
        Y.TEMP = EB.SystemTables.getRNew(LC.Contract.Drawings.TfDrLocalRef)
        Y.TEMP<1,Y.COL.NO.POS> = Y.IDB.ID
        EB.SystemTables.setRNew(LC.Contract.Drawings.TfDrLocalRef, Y.TEMP)
    END ELSE
        Y.IDB.ID = Y.BRANCH.CODE:Y.LC.CODE:Y.YR.LC:Y.SEQ.NO
        Y.TEMP = EB.SystemTables.getRNew(LC.Contract.Drawings.TfDrLocalRef)
        Y.TEMP<1,Y.COL.NO.POS> = Y.IDB.ID
        EB.SystemTables.setRNew(LC.Contract.Drawings.TfDrLocalRef, Y.TEMP)
    END


RETURN
*** </region>

END
