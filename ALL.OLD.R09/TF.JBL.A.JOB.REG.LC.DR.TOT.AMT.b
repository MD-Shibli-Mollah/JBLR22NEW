SUBROUTINE TF.JBL.A.JOB.REG.LC.DR.TOT.AMT
*-----------------------------------------------------------------------------
*Attached As    :
*-----------------------------------------------------------------------------
* Modification History :
* 10/8/2020 -                            Creator   - MAHMUDUR RAHMAN (UDOY),
*                                                 FDS Bangladesh Limited
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.BD.BTB.JOB.REGISTER
    
    $USING LC.Contract
    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING EB.LocalReferences


*-----------------------------------------------------------------------------

    IF EB.SystemTables.getVFunction() EQ 'A' THEN
        GOSUB INITIALISE ; *INITIALISATION
        GOSUB OPENFILE ; *FILE OPEN
        GOSUB PROCESS ; *PROCESS BUSINESS LOGIC
    END
    
RETURN
*-----------------------------------------------------------------------------

INITIALISE:
 
    FN.JOB='F.BD.BTB.JOB.REGISTER'
    F.JOB =''
    
    FN.LC = 'F.LETTER.OF.CREDIT'
    F.LC  = ''

    EB.LocalReferences.GetLocRef("LETTER.OF.CREDIT","LT.TF.JOB.NUMBR",LT.TF.JOB.NUMBER.POS)
    
    Y.APP.ID = EB.SystemTables.getIdNew()
    Y.APP = EB.SystemTables.getApplication()
    
    IF Y.APP EQ 'DRAWINGS' THEN
 
        Y.LC.ID   = Y.APP.ID[1,LEN(Y.APP.ID)-2]
        EB.DataAccess.FRead(FN.LC, Y.LC.ID, LC.REC, F.LC, LC.ERR)
        Y.LC.REF = LC.REC<LC.Contract.LetterOfCredit.TfLcLocalRef>
        Y.JOB.NUM = Y.LC.REF<1,LT.TF.JOB.NUMBER.POS>
    END
    ELSE
        
        Y.JOB.NUM = EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcLocalRef)<1,LT.TF.JOB.NUMBER.POS>
        Y.LATEST.SHIP.DATE = EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcLatestShipment)
        Y.LC.ID   = Y.APP.ID
    END
   
RETURN


OPENFILE:

    EB.DataAccess.Opf(FN.JOB,F.JOB)
 
RETURN

PROCESS:
    
    EB.DataAccess.FRead(FN.JOB, Y.JOB.NUM, JOB.REC, F.JOB, ERR.REC)
    Y.LC.AMOUNT     = JOB.REC<BTB.JOB.EX.LC.AMOUNT> ;*ASOSIATE MULTIVALUE FIELD
    Y.LC.AMT.SUM    = SUM(Y.LC.AMOUNT)
    Y.TOT.LC.AMOUNT = DROUND(Y.LC.AMT.SUM,2)
    Y.FOB.VALUE     = JOB.REC<BTB.JOB.EX.NET.FOB.VALUE> ;*ASOSIATE MULTIVALUE FIELD
    Y.TOT.FOB.SUM   = SUM(Y.FOB.VALUE)
    Y.TOT.FOB.VALUE = DROUND(Y.TOT.FOB.SUM,2)
    Y.DR.AMT        = JOB.REC<BTB.JOB.EX.DR.AMT> ;*ASOSIATE MULTIVALUE FIELD
    
    CONVERT SM TO VM IN Y.DR.AMT
     
    Y.TOT.DR.SUM    = SUM(Y.DR.AMT)
    Y.TOT.DR.AMT    = DROUND(Y.TOT.DR.SUM,2)
    Y.TOT.JOB.LC    = JOB.REC<BTB.JOB.EX.TF.REF> ;*ASOSIATE MULTIVALUE FIELD
    
 
    
    Y.LC.COUNT = DCOUNT(Y.TOT.JOB.LC, @VM)
    
    FOR I = 1 TO Y.LC.COUNT
        Y.LC.NUM = Y.TOT.JOB.LC<1,I>
        IF Y.LC.NUM EQ Y.LC.ID THEN
            Y.LC.SHIP.DATE.POS = I
            BREAK
        END
    NEXT I

    JOB.REC<BTB.JOB.TOT.EX.LC.AMT> = Y.TOT.LC.AMOUNT
    JOB.REC<BTB.JOB.TOT.NET.FOB.VALUE> = Y.TOT.FOB.VALUE
    JOB.REC<BTB.JOB.TOT.EX.LC.DRAW.AMT> = Y.TOT.DR.AMT
    Y.TEMP = JOB.REC<BTB.JOB.EX.LC.SHIP.DATE>
    Y.TEMP<1,Y.LC.SHIP.DATE.POS> = Y.LATEST.SHIP.DATE
    IF Y.LATEST.SHIP.DATE GT Y.TEMP<1,Y.LC.SHIP.DATE.POS> THEN
        JOB.REC<BTB.JOB.EX.LC.SHIP.DATE> = Y.TEMP
    END
    Y.DEMO.LC.AMT = JOB.REC<BTB.JOB.TOT.EX.LC.AMT>
    Y.DEMO.FOV.AMT = JOB.REC<BTB.JOB.TOT.EX.LC.AMT>
    Y.DEMO.DRAW.AMT = JOB.REC<BTB.JOB.TOT.EX.LC.AMT>
    

*    WRITE JOB.REC TO F.JOB,Y.JOB.NUM
    EB.DataAccess.FWrite(FN.JOB, Y.JOB.NUM, JOB.REC)
RETURN
*--------------------------------------- --------------------------------------

END
